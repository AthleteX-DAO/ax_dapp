import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:ax_dapp/predict/livestream/livestream_model.dart';
import 'package:ax_dapp/predict/widgets/live_badge.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:flutter/material.dart';

/// Compact livestream card for interleaving in the prediction grid.
class LiveStreamGridCard extends StatefulWidget {
  const LiveStreamGridCard({super.key, required this.stream});

  final LiveStreamModel stream;

  @override
  State<LiveStreamGridCard> createState() => _LiveStreamGridCardState();
}

class _LiveStreamGridCardState extends State<LiveStreamGridCard> {
  bool _isHovered = false;
  bool _showPlayer = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'livestream-grid-${widget.stream.id}';
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = widget.stream.embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow = 'autoplay; encrypted-media; fullscreen'
          ..allowFullscreen = true;
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final thumbnail = widget.stream.effectiveThumbnail;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _showPlayer = !_showPlayer),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.12),
                Colors.white.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? GoldTheme.gold.withOpacity(0.4)
                  : Colors.red.withOpacity(0.2),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _showPlayer
                ? _buildPlayer()
                : _buildPreview(thumbnail),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return Stack(
      fit: StackFit.expand,
      children: [
        HtmlElementView(viewType: _viewId),
        if (widget.stream.isLive)
          const Positioned(
            top: 8,
            left: 8,
            child: LiveBadge(size: LiveBadgeSize.small),
          ),
      ],
    );
  }

  Widget _buildPreview(String? thumbnail) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Thumbnail or placeholder
        if (thumbnail != null)
          Image.network(
            thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.black,
              child: const Icon(Icons.live_tv, color: Colors.white24, size: 40),
            ),
          )
        else
          Container(
            color: Colors.black,
            child: const Icon(Icons.live_tv, color: Colors.white24, size: 40),
          ),

        // Dark overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Play icon
        Center(
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),

        // LIVE badge
        if (widget.stream.isLive)
          const Positioned(
            top: 8,
            left: 8,
            child: LiveBadge(size: LiveBadgeSize.small),
          ),

        // Title at bottom
        Positioned(
          bottom: 8,
          left: 10,
          right: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.stream.title,
                style: textStyle(Colors.white, 13, isBold: true, isUline: false),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: GoldTheme.goldLight,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      widget.stream.sport,
                      style: TextStyle(
                        color: GoldTheme.gold,
                        fontFamily: 'OpenSans',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tap to watch',
                    style: textStyle(Colors.white54, 10, isBold: false, isUline: false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
