import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Two stat cards showing the selected sector's 24h Volume and Open Interest.
class VolumeOiCards extends StatelessWidget {
  const VolumeOiCards({super.key});

  static String _formatNumber(double n) {
    if (n >= 1e9) return '\$${(n / 1e9).toStringAsFixed(1)}B';
    if (n >= 1e6) return '\$${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1e3) return '\$${(n / 1e3).toStringAsFixed(1)}K';
    return '\$${n.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return BlocBuilder<VoteBloc, VoteState>(
      buildWhen: (prev, curr) =>
          prev.selectedTab != curr.selectedTab ||
          prev.currentSectorStats != curr.currentSectorStats,
      builder: (context, state) {
        final stats = state.currentSectorStats;
        final sectorName = state.selectedTab.displayName;

        final volumeCard = _StatCard(
          label: '24H Volume',
          subtitle: sectorName,
          value: _formatNumber(stats.volume24h),
          icon: Icons.bar_chart,
          isMobile: isMobile,
        );

        final oiCard = _StatCard(
          label: 'Open Interest',
          subtitle: sectorName,
          value: _formatNumber(stats.openInterest),
          icon: Icons.donut_large,
          isMobile: isMobile,
        );

        if (isMobile) {
          return Column(
            children: [
              volumeCard,
              const SizedBox(height: 12),
              oiCard,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: volumeCard),
            const SizedBox(width: 12),
            Expanded(child: oiCard),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.isMobile,
  });

  final String label;
  final String subtitle;
  final String value;
  final IconData icon;
  final bool isMobile;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final valueSize = widget.isMobile ? 16.0 : 20.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: GoldTheme.panel().copyWith(
          border: Border.all(
            color: _hovering
                ? GoldTheme.gold.withOpacity(0.4)
                : Colors.white.withOpacity(0.15),
          ),
          boxShadow: _hovering
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
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: GoldTheme.gold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: GoldTheme.gold,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: textStyle(
                      Colors.white54,
                      12,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: textStyle(
                      Colors.white54,
                      10,
                      isBold: false,
                      isUline: false,
                    ),
                  ),
                ],
              ),
            ),
            // Value with animated transitions
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                widget.value,
                key: ValueKey<String>(widget.value),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: valueSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
