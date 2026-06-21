import 'package:ax_dapp/vote/models/exchange_tab.dart';
import 'package:ax_dapp/vote/models/trade_record.dart';
import 'package:ax_dapp/vote/models/trader_summary.dart';
import 'package:equatable/equatable.dart';

/// Aggregated statistics for one exchange vertical (sector).
class SectorStats extends Equatable {
  const SectorStats({
    required this.sector,
    required this.volume24h,
    required this.openInterest,
    required this.tradeCount24h,
    required this.recentTrades,
    required this.topTraders,
  });

  final ExchangeTab sector;
  final double volume24h;
  final double openInterest;
  final int tradeCount24h;
  final List<TradeRecord> recentTrades;
  final List<TraderSummary> topTraders;

  /// Returns an empty [SectorStats] for a given [sector].
  static SectorStats empty(ExchangeTab sector) => SectorStats(
        sector: sector,
        volume24h: 0,
        openInterest: 0,
        tradeCount24h: 0,
        recentTrades: const [],
        topTraders: const [],
      );

  @override
  List<Object?> get props => [
        sector,
        volume24h,
        openInterest,
        tradeCount24h,
        recentTrades,
        topTraders,
      ];
}
