import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:ax_dapp/predict/livestream/livestream_model.dart';
import 'package:ax_dapp/predict/widgets/live_badge.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:flutter/material.dart';

/// Hero card for a featured livestream in the prediction carousel.
class LiveStreamHeroCard extends StatefulWidget {
  const LiveStreamHeroCard({super.key, required this.stream});

  final LiveStreamModel stream;

  @override
  State<LiveStreamHeroCard> createState() => _LiveStreamHeroCardState();
}

class _LiveStreamHeroCardState extends State<LiveStreamHeroCard> {
  bool _isHovered = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'livestream-hero-${widget.stream.id}';
    // Register the iframe HTML element for Flutter web
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? GoldTheme.gold.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Embedded player
              HtmlElementView(viewType: _viewId),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // Top-left LIVE badge
              if (widget.stream.isLive)
                const Positioned(
                  top: 12,
                  left: 12,
                  child: LiveBadge(),
                ),

              // Sport badge top-right
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    widget.stream.sport,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Bottom content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.stream.title,
                            style: textStyle(
                              Colors.white,
                              18,
                              isBold: true,
                              isUline: false,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.stream.metadata.containsKey('league')) ...[
                            const SizedBox(height: 4),
                            Text(
                              widget.stream.metadata['league']!,
                              style: textStyle(
                                Colors.white54,
                                12,
                                isBold: false,
                                isUline: false,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.stream.marketId != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: GoldTheme.goldButton(radius: 8),
                        child: const Text(
                          'Trade',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
