import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Two hero stat cards — 24H Trading Volume and Total Open Interest.
/// Responsive: side-by-side on desktop, stacked on mobile (< 600).
class ExchangeHeaderStats extends StatelessWidget {
  const ExchangeHeaderStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VoteState>(
      buildWhen: (prev, curr) =>
          prev.totalVolume24h != curr.totalVolume24h ||
          prev.totalOpenInterest != curr.totalOpenInterest,
      builder: (context, state) {
        final volumeCard = _StatCard(
          label: '24H Trading Volume',
          value: state.totalVolume24h,
          accentColor: const Color(0xFF3ABD4A),
          icon: Icons.show_chart,
        );
        final oiCard = _StatCard(
          label: 'Total Open Interest',
          value: state.totalOpenInterest,
          accentColor: GoldTheme.gold,
          icon: Icons.account_balance,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              return Column(
                children: [
                  volumeCard,
                  const SizedBox(height: 16),
                  oiCard,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: volumeCard),
                const SizedBox(width: 16),
                Expanded(child: oiCard),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Private stat card with hover animation
// ---------------------------------------------------------------------------

class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.accentColor,
    required this.icon,
  });

  final String label;
  final double value;
  final Color accentColor;
  final IconData icon;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  // Format: < 1000 as-is, >= 1K, >= 1M, >= 1B
  static String _formatValue(double n) {
    if (n >= 1e9) return '\$${(n / 1e9).toStringAsFixed(1)}B';
    if (n >= 1e6) return '\$${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1e3) return '\$${(n / 1e3).toStringAsFixed(1)}K';
    return '\$${n.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final valueSize = isMobile ? 22.0 : 28.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: GoldTheme.panel().copyWith(
          border: Border.all(
            color: _hovered
                ? GoldTheme.gold.withOpacity(0.4)
                : Colors.white.withOpacity(0.15),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: GoldTheme.gold.withOpacity(0.15),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: widget.accentColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),

            // Label + value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label row with colored dot
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.accentColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.label,
                        style: textStyle(
                          Colors.white54,
                          13,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Animated number
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: Text(
                      _formatValue(widget.value),
                      key: ValueKey<double>(widget.value),
                      style: textStyle(
                        Colors.white,
                        valueSize,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
