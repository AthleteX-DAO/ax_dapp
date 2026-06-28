import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/trade_slip/models/trade_slip_data.dart';
import 'package:ax_dapp/trade_slip/widgets/trade_slip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Dialog that wraps a [TradeSlipCard] with share, download, and copy actions.
///
/// Reuses the same `/api/v1/share-card` endpoint and PNG capture pattern
/// from [AthleteShareCardDialog].
class TradeSlipDialog extends StatelessWidget {
  const TradeSlipDialog({
    required this.slip,
    super.key,
  });

  /// The trade data to display.
  final TradeSlipData slip;

  /// Show the dialog as a modal.
  static Future<void> show(BuildContext context, {required TradeSlipData slip}) {
    return showDialog<void>(
      context: context,
      builder: (_) => TradeSlipDialog(slip: slip),
    );
  }

  String get _shareText {
    if (slip.type == SlipType.prediction) {
      final side = slip.side == SlipSide.yes ? 'YES' : 'NO';
      final payout = slip.potentialPayout?.toStringAsFixed(2) ?? '?';
      return 'I just placed a $side bet on "${slip.marketName}" on AthleteX!\n'
          'Odds: ${slip.price.toStringAsFixed(2)} | '
          'Potential Payout: \$$payout\n'
          'Think you can beat me? 🏆';
    } else {
      final side = slip.side == SlipSide.buy ? 'bought' : 'sold';
      return 'I just $side ${slip.marketName} at '
          '\$${slip.price.toStringAsFixed(4)} on AthleteX!\n'
          'Amount: \$${slip.amount.toStringAsFixed(2)} axUSD\n'
          'Join the exchange 🚀';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardKey = GlobalKey();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The card (wrapped in RepaintBoundary for PNG capture)
          RepaintBoundary(
            key: cardKey,
            child: TradeSlipCard(slip: slip),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SlipActionButton(
                icon: Icons.download_rounded,
                label: 'Save',
                onPressed: () => _downloadCard(cardKey),
              ),
              const SizedBox(width: 8),
              _SlipActionButton(
                icon: Icons.close_rounded,
                label: '',
                onPressed: () => Navigator.of(context).pop(),
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Social share buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SocialShareButton(
                label: '𝕏',
                onPressed: () => _shareWithImage(cardKey, 'twitter'),
              ),
              const SizedBox(width: 8),
              _SocialShareButton(
                label: 'f',
                onPressed: () => _shareWithImage(cardKey, 'facebook'),
              ),
              const SizedBox(width: 8),
              _SocialShareButton(
                icon: Icons.link_rounded,
                onPressed: () => _shareWithImage(
                  cardKey,
                  'copy',
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── PNG capture & share ───────────────────────────────────────

  Future<Uint8List?> _captureCard(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      debugPrint('Card capture failed: $e');
      return null;
    }
  }

  Future<void> _downloadCard(GlobalKey key) async {
    final bytes = await _captureCard(key);
    if (bytes == null) return;

    final slug = slip.marketName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'athletex_slip_$slug.png')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _shareWithImage(
    GlobalKey cardKey,
    String platform, {
    BuildContext? context,
  }) async {
    try {
      final bytes = await _captureCard(cardKey);
      if (bytes == null) return;

      final shareUrl = await _uploadToBackend(bytes);

      switch (platform) {
        case 'twitter':
          final text = Uri.encodeComponent(_shareText);
          final url = Uri.encodeComponent(shareUrl);
          html.window.open(
            'https://twitter.com/intent/tweet?text=$text&url=$url',
            '_blank',
          );
          break;
        case 'facebook':
          final url = Uri.encodeComponent(shareUrl);
          html.window.open(
            'https://www.facebook.com/sharer/sharer.php?u=$url',
            '_blank',
          );
          break;
        case 'copy':
          html.window.navigator.clipboard?.writeText(
            '$_shareText\n$shareUrl',
          );
          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Copied to clipboard!'),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFFFFC600),
              ),
            );
          }
          break;
      }
    } catch (e) {
      debugPrint('Share failed: $e');
      // Fallback: text-only share
      if (platform == 'twitter') {
        final text = Uri.encodeComponent(_shareText);
        html.window.open(
          'https://twitter.com/intent/tweet?text=$text',
          '_blank',
        );
      }
    }
  }

  Future<String> _uploadToBackend(Uint8List bytes) async {
    final formData = html.FormData();
    final blob = html.Blob([bytes], 'image/png');
    formData.appendBlob('image', blob, 'slip.png');
    formData.append('name', slip.marketName);
    formData.append('type', slip.type.name);
    formData.append('side', slip.side.name);
    formData.append('amount', slip.amount.toStringAsFixed(2));

    final request = html.HttpRequest();
    request.open('POST', '$baseApiUrl/api/v1/share-card');

    final completer = Completer<String>();
    request.onLoad.listen((_) {
      if (request.status == 200) {
        final json =
            jsonDecode(request.responseText!) as Map<String, dynamic>;
        completer.complete(json['share_url'] as String);
      } else {
        completer.completeError('Upload failed: ${request.status}');
      }
    });
    request.onError.listen((_) {
      completer.completeError('Network error uploading trade slip');
    });
    request.send(formData);

    return completer.future;
  }
}

// ─────────────────────────────────────────────────────────────────────
// Internal button widgets
// ─────────────────────────────────────────────────────────────────────

class _SlipActionButton extends StatelessWidget {
  const _SlipActionButton({
    required this.icon,
    required this.onPressed,
    this.label = '',
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: 10,
          ),
          decoration: GoldTheme.panel(radius: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: GoldTheme.gold, size: 18),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialShareButton extends StatelessWidget {
  const _SocialShareButton({
    this.label,
    this.icon,
    required this.onPressed,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 18)
                : Text(
                    label ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
