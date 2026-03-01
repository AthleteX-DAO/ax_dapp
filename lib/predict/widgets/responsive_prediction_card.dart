import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/service/responsive_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AthleteX-style prediction market card — info-focused display
/// Shows market title, volume, and outcome percentages with minimal UI
class ResponsivePredictionCard extends StatefulWidget {
  const ResponsivePredictionCard({
    super.key,
    required this.prediction,
  });

  final PredictionModel prediction;

  @override
  State<ResponsivePredictionCard> createState() =>
      _ResponsivePredictionCardState();
}

class _ResponsivePredictionCardState extends State<ResponsivePredictionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveConstants.isMobile(width);
    final padding =
        ResponsiveConstants.getPadding(width, size: PaddingSize.medium);

    final longPercentage = widget.prediction.longTokenPercentage ?? 0;
    final shortPercentage = widget.prediction.shortTokenPercentage ?? 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Navigate to prediction details page
          context.goNamed(
            'prediction',
            pathParameters: {
              'id': widget.prediction.id.toString() + widget.prediction.prompt,
            },
            extra: widget.prediction,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? GoldTheme.gold.withOpacity(0.4)
                  : Colors.white.withOpacity(0.15),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: GoldTheme.gold.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Market title (emphasized, matches placeholder size)
                Text(
                  widget.prediction.prompt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle(
                    Colors.white,
                    isMobile ? 16 : 20,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 10),

                // Trading volume (simple bold line)
                Text(
                  'Vol: \$${(widget.prediction.tradingVolume / 1e6).toStringAsFixed(1)}M',
                  style: textStyle(
                    Colors.white70,
                    isMobile ? 12 : 13,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 14),

                // Subtle horizontal divider
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Outcome percentages with labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // YES outcome
                    Column(
                      children: [
                        Text(
                          '${longPercentage.toStringAsFixed(0)}%',
                          style: textStyle(
                            GoldTheme.gold,
                            isMobile ? 22 : 24,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Yes',
                          style: textStyle(
                            Colors.white54,
                            isMobile ? 11 : 12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '/',
                        style: textStyle(
                          Colors.white30,
                          isMobile ? 18 : 20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ),
                    // NO outcome
                    Column(
                      children: [
                        Text(
                          '${shortPercentage.toStringAsFixed(0)}%',
                          style: textStyle(
                            Colors.white,
                            isMobile ? 22 : 24,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'No',
                          style: textStyle(
                            Colors.white54,
                            isMobile ? 11 : 12,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
