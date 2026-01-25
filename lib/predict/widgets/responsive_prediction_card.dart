import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/inline_betting_interface.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/service/responsive_constants.dart';
// import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Responsive prediction market card for grid display
/// Shows market info and unified bet buttons with integrated pricing
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

class _ResponsivePredictionCardState extends State<ResponsivePredictionCard>
    with SingleTickerProviderStateMixin {
  bool _expandedYes = false;
  bool _expandedNo = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = ResponsiveConstants.isMobile(width);
    final padding =
        ResponsiveConstants.getPadding(width, size: PaddingSize.medium);

    return GestureDetector(
      onTap: () {
        // Navigate to the prediction details page when tapping anywhere on card
        context.goNamed(
          'prediction',
          pathParameters: {
            'id': widget.prediction.id.toString() + widget.prediction.prompt,
          },
          extra: widget.prediction,
        );
      },
      onHorizontalDragEnd: (details) {
        final delta = details.velocity.pixelsPerSecond.dx;
        // Swipe right for Yes
        if (delta > 500) {
          setState(() {
            _expandedYes = true;
            _expandedNo = false;
          });
        }
        // Swipe left for No
        else if (delta < -500) {
          setState(() {
            _expandedNo = true;
            _expandedYes = false;
          });
        }
      },
      child: Container(
        decoration: GoldTheme.panel(radius: 12),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title and volume
                GestureDetector(
                  onTap: () {
                    context.goNamed(
                      'prediction',
                      pathParameters: {
                        'id': widget.prediction.id.toString() +
                            widget.prediction.prompt,
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prediction.prompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle(
                          Colors.white,
                          isMobile ? 13 : 14,
                          isBold: true,
                          isUline: false,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Vol: \$${(widget.prediction.tradingVolume / 1e6).toStringAsFixed(1)}M',
                        style: textStyle(
                          Colors.white54,
                          isMobile ? 11 : 12,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Inline betting interfaces for Yes/No
                InlineBettingInterface(
                  predictionModel: widget.prediction,
                  isYes: true,
                  expanded: _expandedYes,
                  onBet: (amount) {
                    // TODO: Handle bet placement
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Betting \$$amount on Yes'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                if (_expandedYes) const SizedBox(height: 8),
                InlineBettingInterface(
                  predictionModel: widget.prediction,
                  isYes: false,
                  expanded: _expandedNo,
                  onBet: (amount) {
                    // TODO: Handle bet placement
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Betting \$$amount on No'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),

                // Unified action buttons with integrated pricing - only show if not expanded
                if (!_expandedYes && !_expandedNo) ...[
                  const SizedBox(height: 12),
                  _UnifiedBetButton(
                    label: 'Yes',
                    percentage: widget.prediction.longTokenPercentage ?? 0,
                    price: widget.prediction.longTokenPrice ?? 0,
                    color: GoldTheme.gold,
                    isMobile: isMobile,
                    onTap: () => setState(() => _expandedYes = true),
                  ),
                  const SizedBox(height: 8),
                  _UnifiedBetButton(
                    label: 'No',
                    percentage: widget.prediction.shortTokenPercentage ?? 0,
                    price: widget.prediction.shortTokenPrice ?? 0,
                    color: Colors.black,
                    isMobile: isMobile,
                    onTap: () => setState(() => _expandedNo = true),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Unified button showing outcome, probability, and price
class _UnifiedBetButton extends StatelessWidget {
  const _UnifiedBetButton({
    required this.label,
    required this.percentage,
    required this.price,
    required this.color,
    required this.isMobile,
    required this.onTap,
  });

  final String label;
  final double percentage;
  final double price;
  final Color color;
  final bool isMobile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final percentStr = percentage.toStringAsFixed(0);
    final priceStr = (price * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Action label
            Text(
              'Bet $label',
              style: textStyle(
                color,
                isMobile ? 13 : 14,
                isBold: true,
                isUline: false,
              ),
            ),
            // Spacing
            const Spacer(),
            // Probability and price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$percentStr%',
                  style: textStyle(
                    Colors.white,
                    isMobile ? 12 : 13,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                Text(
                  '${priceStr}¢',
                  style: textStyle(
                    Colors.white70,
                    isMobile ? 11 : 12,
                    isBold: false,
                    isUline: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
