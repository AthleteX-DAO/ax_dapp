import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/versus/models/athlete_elo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Shows a shareable athlete stats card and allows PNG download / social sharing.
class AthleteShareCardDialog extends StatelessWidget {
  const AthleteShareCardDialog({
    required this.athlete,
    required this.rank,
    required this.category,
    super.key,
  });

  final AthleteElo athlete;
  final int rank;
  final String category;

  // TODO: update to production URL
  static const _backendBase = 'http://localhost:8000';

  String get _shareText =>
      '${athlete.athleteName} is ranked #$rank in $category on AthleteX!\n'
      'ELO: ${athlete.elo.toStringAsFixed(0)} | Record: ${athlete.record} | '
      'Win%: ${athlete.winRate.toStringAsFixed(1)}%\n'
      'Do you agree? Vote now 👇';

  static Future<void> show(
    BuildContext context, {
    required AthleteElo athlete,
    required int rank,
    required String category,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AthleteShareCardDialog(
        athlete: athlete,
        rank: rank,
        category: category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardKey = GlobalKey();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The card itself (wrapped in RepaintBoundary for capture)
          RepaintBoundary(
            key: cardKey,
            child: _ShareCard(
              athlete: athlete,
              rank: rank,
              category: category,
            ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.download_rounded,
                label: 'Save',
                onPressed: () {
                  context.read<TrackingCubit>().trackVersusShareCard(
                        athleteName: athlete.athleteName,
                        walletId: '',
                      );
                  _downloadCard(cardKey);
                },
              ),
              const SizedBox(width: 8),
              _ActionButton(
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
              _SocialButton(
                label: '𝕏',
                onPressed: () {
                  context.read<TrackingCubit>().trackVersusShareCard(
                        athleteName: athlete.athleteName,
                        walletId: '',
                      );
                  _shareWithImage(cardKey, 'twitter');
                },
              ),
              const SizedBox(width: 8),
              _SocialButton(
                label: 'f',
                onPressed: () {
                  context.read<TrackingCubit>().trackVersusShareCard(
                        athleteName: athlete.athleteName,
                        walletId: '',
                      );
                  _shareWithImage(cardKey, 'facebook');
                },
              ),
              const SizedBox(width: 8),
              _SocialButton(
                icon: Icons.link_rounded,
                onPressed: () {
                  context.read<TrackingCubit>().trackVersusShareCard(
                        athleteName: athlete.athleteName,
                        walletId: '',
                      );
                  _shareWithImage(cardKey, 'copy', context: context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Capture the card PNG, upload to backend, then share the returned URL.
  Future<void> _shareWithImage(
    GlobalKey cardKey,
    String platform, {
    BuildContext? context,
  }) async {
    try {
      final bytes = await _captureCard(cardKey);
      if (bytes == null) return;

      // Upload to backend
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
      // Fallback: just share text without image
      if (platform == 'twitter') {
        final text = Uri.encodeComponent(_shareText);
        html.window.open(
          'https://twitter.com/intent/tweet?text=$text',
          '_blank',
        );
      }
    }
  }

  /// Upload the PNG to ax-server and return the share page URL.
  Future<String> _uploadToBackend(Uint8List bytes) async {
    final formData = html.FormData();
    final blob = html.Blob([bytes], 'image/png');
    formData.appendBlob('image', blob, 'card.png');
    formData.append('name', athlete.athleteName);
    formData.append('rank', '$rank');
    formData.append('category', category);
    formData.append('elo', athlete.elo.toStringAsFixed(0));
    formData.append('record', athlete.record);
    formData.append('win_pct', athlete.winRate.toStringAsFixed(1));

    final request = html.HttpRequest();
    request.open('POST', '$_backendBase/api/v1/share-card');

    final completer = Completer<String>();
    request.onLoad.listen((_) {
      if (request.status == 200) {
        final json = jsonDecode(request.responseText!) as Map<String, dynamic>;
        completer.complete(json['share_url'] as String);
      } else {
        completer.completeError('Upload failed: ${request.status}');
      }
    });
    request.onError.listen((_) {
      completer.completeError('Network error uploading share card');
    });
    request.send(formData);

    return completer.future;
  }

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

    final slug = athlete.athleteName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_');
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'athletex_$slug.png')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

// ─────────────────────────────────────────────────────────────────────
// The actual card design
// ─────────────────────────────────────────────────────────────────────

class _ShareCard extends StatelessWidget {
  const _ShareCard({
    required this.athlete,
    required this.rank,
    required this.category,
  });

  final AthleteElo athlete;
  final int rank;
  final String category;

  String get _rankSuffix {
    if (rank == 1) return 'st';
    if (rank == 2) return 'nd';
    if (rank == 3) return 'rd';
    return 'th';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryOrangeColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryOrangeColor.withOpacity(0.15),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top bar: logo + category ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.close, // X logo placeholder
                    color: primaryOrangeColor,
                    size: 22,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'AthleteX',
                    style: TextStyle(
                      color: Color(0xFFFFC600),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'OpenSans',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryOrangeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: primaryOrangeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Avatar circle ──
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryOrangeColor,
                  primaryOrangeColor.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryOrangeColor.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _initials,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Name ──
          Text(
            athlete.athleteName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'OpenSans',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            athlete.team,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 13,
              fontFamily: 'OpenSans',
            ),
          ),
          const SizedBox(height: 20),

          // ── Rank badge ──
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: rank <= 3
                  ? LinearGradient(
                      colors: [
                        _rankGradientColor.withOpacity(0.3),
                        _rankGradientColor.withOpacity(0.1),
                      ],
                    )
                  : null,
              color: rank > 3 ? Colors.white.withOpacity(0.08) : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: rank <= 3
                    ? _rankGradientColor.withOpacity(0.5)
                    : Colors.white.withOpacity(0.15),
              ),
            ),
            child: Text(
              '#$rank$_rankSuffix Ranked',
              style: TextStyle(
                color: rank <= 3 ? _rankGradientColor : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Stats row ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatColumn(
                value: athlete.elo.toStringAsFixed(0),
                label: 'ELO',
                color: primaryOrangeColor,
              ),
              _StatDivider(),
              _StatColumn(
                value: athlete.record,
                label: 'RECORD',
                color: Colors.white,
              ),
              _StatDivider(),
              _StatColumn(
                value: '${athlete.winRate.toStringAsFixed(1)}%',
                label: 'WIN%',
                color: athlete.winRate >= 50
                    ? primaryGreenColor
                    : primaryRedColor,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String get _initials {
    final parts = athlete.athleteName.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return athlete.athleteName.substring(0, 2).toUpperCase();
  }

  Color get _rankGradientColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.white;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────
// Small helper widgets
// ─────────────────────────────────────────────────────────────────────

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: 'OpenSans',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
            fontWeight: FontWeight.w600,
            fontFamily: 'OpenSans',
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withOpacity(0.1),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 10 : 20,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: _hovering
                ? Colors.white.withOpacity(0.12)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(_hovering ? 0.3 : 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              if (widget.label.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class _SocialButton extends StatefulWidget {
  const _SocialButton({
    required this.onPressed,
    this.label,
    this.icon,
  });

  final VoidCallback onPressed;
  final String? label;
  final IconData? icon;

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _hovering
                ? primaryOrangeColor.withOpacity(0.2)
                : Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovering
                  ? primaryOrangeColor.withOpacity(0.5)
                  : Colors.white.withOpacity(0.15),
            ),
          ),
          child: Center(
            child: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: _hovering ? primaryOrangeColor : Colors.white,
                    size: 20,
                  )
                : Text(
                    widget.label ?? '',
                    style: TextStyle(
                      color: _hovering ? primaryOrangeColor : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

