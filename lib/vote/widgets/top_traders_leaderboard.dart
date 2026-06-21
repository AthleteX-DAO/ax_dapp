import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopTradersLeaderboard extends StatelessWidget {
  const TopTradersLeaderboard({super.key});

  static String _formatNumber(double n) {
    if (n >= 1e9) return '\$${(n / 1e9).toStringAsFixed(1)}B';
    if (n >= 1e6) return '\$${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1e3) return '\$${(n / 1e3).toStringAsFixed(1)}K';
    return '\$${n.toStringAsFixed(2)}';
  }

  static Color _rankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.white54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VoteState>(
      buildWhen: (prev, curr) =>
          prev.currentSectorStats != curr.currentSectorStats,
      builder: (context, state) {
        final traders = state.currentSectorStats.topTraders.take(10).toList();

        return Container(
          decoration: GoldTheme.panel(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header bar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: GoldTheme.darkPanel(radius: 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: GoldTheme.gold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Top Traders',
                      style: textStyle(
                        Colors.white,
                        16,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${traders.length} traders',
                      style: textStyle(
                        Colors.white54,
                        12,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              if (traders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          color: GoldTheme.gold.withOpacity(0.4),
                          size: 36,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No trader data available',
                          style: textStyle(
                            GoldTheme.gold,
                            14,
                            isBold: false,
                            isUline: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...List.generate(traders.length, (index) {
                  final trader = traders[index];
                  final rank = index + 1;
                  final color = _rankColor(rank);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (index > 0)
                        Divider(
                          color: Colors.white.withOpacity(0.06),
                          height: 1,
                        ),
                      _TraderRow(
                        trader: trader,
                        rank: rank,
                        rankColor: color,
                      ),
                    ],
                  );
                }),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}

class _TraderRow extends StatefulWidget {
  const _TraderRow({
    required this.trader,
    required this.rank,
    required this.rankColor,
  });

  final TraderSummary trader;
  final int rank;
  final Color rankColor;

  @override
  State<_TraderRow> createState() => _TraderRowState();
}

class _TraderRowState extends State<_TraderRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _hovered ? Colors.white.withOpacity(0.04) : Colors.transparent,
          border: Border.all(
            color: _hovered
                ? GoldTheme.gold.withOpacity(0.4)
                : Colors.transparent,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: GoldTheme.gold.withOpacity(0.15),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Rank badge
            CircleAvatar(
              radius: 14,
              backgroundColor: widget.rankColor.withOpacity(
                widget.rank <= 3 ? 0.2 : 0.1,
              ),
              child: Text(
                '#${widget.rank}',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 11,
                  fontWeight:
                      widget.rank <= 3 ? FontWeight.w700 : FontWeight.w400,
                  color: widget.rankColor,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Address
            Expanded(
              child: Text(
                widget.trader.shortAddress,
                style: textStyle(
                  Colors.white,
                  13,
                  isBold: false,
                  isUline: false,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),

            // Volume & trade count
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  TopTradersLeaderboard._formatNumber(widget.trader.totalVolume),
                  style: textStyle(
                    Colors.white,
                    13,
                    isBold: true,
                    isUline: false,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.trader.tradeCount} trades',
                  style: textStyle(
                    Colors.white54,
                    10,
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
