import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/vote/bloc/vote_bloc.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Scrollable list of recent trades for the selected sector.
class TradingHistoryTable extends StatelessWidget {
  const TradingHistoryTable({super.key});

  static const _buyColor = Color(0xFF3ABD4A);
  static const _sellColor = Color(0xFFEC2131);

  static String _relativeTime(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteBloc, VoteState>(
      buildWhen: (prev, curr) =>
          prev.currentSectorStats != curr.currentSectorStats,
      builder: (context, state) {
        final trades = state.currentSectorStats.recentTrades.take(50).toList();

        return Container(
          decoration: GoldTheme.panel(),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header bar ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: GoldTheme.darkPanel(radius: 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.swap_vert_rounded,
                      color: GoldTheme.gold,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Recent Trades',
                      style: textStyle(
                        Colors.white,
                        16,
                        isBold: true,
                        isUline: false,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Column headers ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: const [
                    _HeaderCell('Time', flex: 2),
                    _HeaderCell('Trader', flex: 2),
                    _HeaderCell('Market', flex: 2),
                    _HeaderCell('Side', flex: 1),
                    _HeaderCell('Amount', flex: 2),
                  ],
                ),
              ),

              Divider(
                height: 1,
                color: Colors.white.withOpacity(0.08),
              ),

              // ── Body ──
              if (trades.isEmpty)
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_rounded,
                          color: GoldTheme.gold.withOpacity(0.5),
                          size: 36,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No recent trades',
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
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: trades.length,
                    itemBuilder: (context, index) {
                      final trade = trades[index];
                      final isBuy = trade.side.toLowerCase() == 'buy';
                      final sideColor = isBuy ? _buyColor : _sellColor;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        color: index.isEven
                            ? Colors.white.withOpacity(0.03)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            // Time
                            _DataCell(
                              _relativeTime(trade.timestamp),
                              flex: 2,
                              color: Colors.white54,
                            ),
                            // Trader
                            _DataCell(
                              trade.shortAddress,
                              flex: 2,
                              color: Colors.white70,
                            ),
                            // Market
                            _DataCell(
                              trade.marketName,
                              flex: 2,
                              color: Colors.white,
                            ),
                            // Side
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: sideColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isBuy ? 'BUY' : 'SELL',
                                    style: TextStyle(
                                      color: sideColor,
                                      fontSize: 11,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Amount
                            _DataCell(
                              '\$${trade.amount.toStringAsFixed(2)}',
                              flex: 2,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ── Private helper widgets ──────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.flex = 1});

  final String text;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: textStyle(
          Colors.white54,
          11,
          isBold: true,
          isUline: false,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  const _DataCell(this.text, {this.flex = 1, this.color = Colors.white});

  final String text;
  final int flex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: textStyle(
          color,
          12,
          isBold: false,
          isUline: false,
        ),
      ),
    );
  }
}
