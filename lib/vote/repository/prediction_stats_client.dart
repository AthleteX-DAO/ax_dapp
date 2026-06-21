import 'dart:convert';

import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/predict/data/firebase_price_client.dart';
import 'package:ax_dapp/predict/repository/live_prediction_market_repository.dart';
import 'package:ax_dapp/vote/models/trade_record.dart';
import 'package:ax_dapp/vote/models/trader_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Gathers prediction-market statistics from the ax-server API and
/// [LivePredictionMarketRepository].
class PredictionStatsClient {
  PredictionStatsClient({
    required LivePredictionMarketRepository livePredictionMarketRepository,
    required FirebasePriceClient firebasePriceClient,
    http.Client? httpClient,
    String? apiBaseUrl,
  })  : _liveRepo = livePredictionMarketRepository,
        _firebasePriceClient = firebasePriceClient,
        _httpClient = httpClient ?? http.Client(),
        _apiBaseUrl = apiBaseUrl ?? baseApiUrl;

  final LivePredictionMarketRepository _liveRepo;
  // ignore: unused_field
  final FirebasePriceClient _firebasePriceClient;
  final http.Client _httpClient;
  final String _apiBaseUrl;

  /// Fetches 24h volume from the API, falls back to on-chain sum.
  Future<double> getPredictionVolume() async {
    try {
      // Try API first
      final url = '$_apiBaseUrl/api/v1/predict/stats/volume';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return (json['volume_24h'] as num?)?.toDouble() ?? 0;
      }
    } catch (e) {
      debugPrint('[PredictionStatsClient] API volume error: $e');
    }

    // Fall back to on-chain sum
    try {
      final markets = await _liveRepo.getLivePredictionMarkets();
      var total = 0.0;
      for (final market in markets) {
        total += market.tradingVolume;
      }
      return total;
    } catch (e) {
      debugPrint('[PredictionStatsClient] volume error: $e');
      return 0;
    }
  }

  /// Proxy for open interest: sums (yesTokenSupply value) across active markets.
  Future<double> getPredictionOpenInterest() async {
    try {
      final markets = await _liveRepo.getLivePredictionMarkets();
      var total = 0.0;
      for (final market in markets) {
        final yesOI = (market.longTokenPrice ?? 0) * market.tradingVolume;
        final noOI = (market.shortTokenPrice ?? 0) * market.tradingVolume;
        total += yesOI + noOI;
      }
      return total;
    } catch (e) {
      debugPrint('[PredictionStatsClient] open interest error: $e');
      return 0;
    }
  }

  /// Fetches recent prediction trades from the API.
  Future<List<TradeRecord>> getRecentPredictionTrades() async {
    try {
      final url = '$_apiBaseUrl/api/v1/predict/stats/trades?limit=50';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final trades = json['trades'] as List<dynamic>? ?? [];
        return trades.map((t) {
          final map = t as Map<String, dynamic>;
          return TradeRecord(
            walletAddress: map['wallet'] as String? ?? '',
            side: map['side'] as String? ?? 'buy',
            amount: (map['amount_usd'] as num?)?.toDouble() ?? 0,
            price: (map['price'] as num?)?.toDouble() ?? 0,
            timestamp: DateTime.tryParse(
                  map['timestamp'] as String? ?? '',
                ) ??
                DateTime.now(),
            txHash: map['tx_hash'] as String? ?? '',
            tokenSymbol: map['token_symbol'] as String? ?? '',
            marketName: map['market_name'] as String? ?? '',
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('[PredictionStatsClient] trades error: $e');
    }
    return const [];
  }

  /// Fetches top prediction traders from the API.
  Future<List<TraderSummary>> getTopPredictionTraders() async {
    try {
      final url = '$_apiBaseUrl/api/v1/predict/stats/leaderboard?limit=10';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final traders = json['traders'] as List<dynamic>? ?? [];
        return traders.map((t) {
          final map = t as Map<String, dynamic>;
          return TraderSummary(
            walletAddress: map['wallet'] as String? ?? '',
            totalVolume: (map['total_volume'] as num?)?.toDouble() ?? 0,
            tradeCount: map['trade_count'] as int? ?? 0,
            lastTradeTimestamp: DateTime.tryParse(
                  map['last_trade'] as String? ?? '',
                ) ??
                DateTime.now(),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('[PredictionStatsClient] leaderboard error: $e');
    }
    return const [];
  }
}
