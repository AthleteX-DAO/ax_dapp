import 'package:ax_dapp/service/controller/perps/perps_repository.dart';
import 'package:ax_dapp/vote/models/models.dart';
import 'package:ax_dapp/vote/repository/dex_subgraph_client.dart';
import 'package:ax_dapp/vote/repository/prediction_stats_client.dart';
import 'package:flutter/foundation.dart';

/// Aggregates exchange statistics across all three verticals
/// (predictions, spot, perps) into unified [SectorStats] objects.
class ExchangeStatsRepository {
  const ExchangeStatsRepository({
    required DexSubgraphClient dexSubgraphClient,
    required PredictionStatsClient predictionStatsClient,
    PerpsRepository? perpsRepository,
  })  : _dexClient = dexSubgraphClient,
        _predictionClient = predictionStatsClient,
        _perpsRepo = perpsRepository;

  final DexSubgraphClient _dexClient;
  final PredictionStatsClient _predictionClient;
  final PerpsRepository? _perpsRepo;

  /// Fetches [SectorStats] for a single [tab].
  Future<SectorStats> getSectorStats(ExchangeTab tab) async {
    switch (tab) {
      case ExchangeTab.predictions:
        return _getPredictionStats();
      case ExchangeTab.spot:
        return _getSpotStats();
      case ExchangeTab.perps:
        return _getPerpsStats();
    }
  }

  /// Sum of 24h volumes across all sectors.
  Future<double> getTotalVolume24h() async {
    final results = await Future.wait([
      _predictionClient.getPredictionVolume(),
      _dexClient.get24hVolume(),
      _getPerpsVolume(),
    ]);
    return results.fold<double>(0, (sum, v) => sum + v);
  }

  /// Sum of open interest across all sectors.
  Future<double> getTotalOpenInterest() async {
    final results = await Future.wait([
      _predictionClient.getPredictionOpenInterest(),
      _dexClient.getTotalValueLocked(),
      _getPerpsOI(),
    ]);
    return results.fold<double>(0, (sum, v) => sum + v);
  }

  // ─── Private sector fetchers ─────────────────────────────────────────

  Future<SectorStats> _getPredictionStats() async {
    try {
      final results = await Future.wait([
        _predictionClient.getPredictionVolume(),
        _predictionClient.getPredictionOpenInterest(),
        _predictionClient.getRecentPredictionTrades(),
        _predictionClient.getTopPredictionTraders(),
      ]);
      return SectorStats(
        sector: ExchangeTab.predictions,
        volume24h: results[0] as double,
        openInterest: results[1] as double,
        tradeCount24h: 0,
        recentTrades: results[2] as List<TradeRecord>,
        topTraders: results[3] as List<TraderSummary>,
      );
    } catch (e) {
      debugPrint('[ExchangeStatsRepository] prediction stats error: $e');
      return SectorStats.empty(ExchangeTab.predictions);
    }
  }

  Future<SectorStats> _getSpotStats() async {
    try {
      final results = await Future.wait([
        _dexClient.get24hVolume(),
        _dexClient.getTotalValueLocked(),
        _dexClient.getRecentSwaps(),
        _dexClient.getTopTraders(),
      ]);
      final trades = results[2] as List<TradeRecord>;
      return SectorStats(
        sector: ExchangeTab.spot,
        volume24h: results[0] as double,
        openInterest: results[1] as double,
        tradeCount24h: trades.length,
        recentTrades: trades,
        topTraders: results[3] as List<TraderSummary>,
      );
    } catch (e) {
      debugPrint('[ExchangeStatsRepository] spot stats error: $e');
      return SectorStats.empty(ExchangeTab.spot);
    }
  }

  Future<SectorStats> _getPerpsStats() async {
    try {
      final oi = await _getPerpsOI();
      return SectorStats(
        sector: ExchangeTab.perps,
        volume24h: 0, // Perps volume not available without subgraph
        openInterest: oi,
        tradeCount24h: 0,
        recentTrades: const [], // Stub — no trade indexer yet
        topTraders: const [],
      );
    } catch (e) {
      debugPrint('[ExchangeStatsRepository] perps stats error: $e');
      return SectorStats.empty(ExchangeTab.perps);
    }
  }

  Future<double> _getPerpsOI() async {
    if (_perpsRepo == null) return 0;
    var totalOI = 0.0;
    for (final symbol in PerpsRepository.marketIds.keys) {
      try {
        final data = await _perpsRepo!.getMarketData(symbol);
        totalOI += data.openInterestUSD;
      } catch (_) {
        // Skip markets that fail
      }
    }
    return totalOI;
  }

  Future<double> _getPerpsVolume() async {
    // Perps 24h volume requires a subgraph — stub for now
    return 0;
  }
}
