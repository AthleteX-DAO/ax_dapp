import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Custom tab bar for switching between Predictions, Spot, and Perps sectors.
class SectorTabBar extends StatelessWidget {
  const SectorTabBar({super.key});

  static const _icons = <ExchangeTab, IconData>{
    ExchangeTab.predictions: Icons.trending_up,
    ExchangeTab.spot: Icons.swap_horiz,
    ExchangeTab.perps: Icons.show_chart,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return BlocBuilder<VoteBloc, VoteState>(
      buildWhen: (prev, curr) => prev.selectedTab != curr.selectedTab,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: GoldTheme.darkPanel(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ExchangeTab.values.map((tab) {
              final isSelected = state.selectedTab == tab;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.read<VoteBloc>().add(SwitchTab(tab: tab)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 12,
                      vertical: 8,
                    ),
                    decoration: isSelected
                        ? GoldTheme.goldPanel()
                        : BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _icons[tab],
                          size: isMobile ? 14 : 16,
                          color: isSelected
                              ? GoldTheme.gold
                              : Colors.white54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tab.displayName,
                          style: textStyle(
                            isSelected ? GoldTheme.gold : Colors.white54,
                            isMobile ? 12 : 13,
                            isBold: isSelected,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
