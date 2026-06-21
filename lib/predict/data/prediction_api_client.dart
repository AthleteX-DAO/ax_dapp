import 'dart:convert';

import 'package:ax_dapp/app/config/app_config.dart';
import 'package:ax_dapp/predict/models/market_price_record.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/models/supported_prediction_markets.dart';
import 'package:ax_dapp/service/prediction_models/prediction_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// HTTP client that fetches prediction market data from the ax-server API.
class PredictionApiClient {
  PredictionApiClient({
    http.Client? httpClient,
    String? apiBaseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _apiBaseUrl = apiBaseUrl ?? baseApiUrl;

  final http.Client _httpClient;
  final String _apiBaseUrl;

  /// Fetch all prediction markets, optionally filtered by [category].
  Future<List<PredictionModel>> fetchMarkets({
    SupportedPredictionMarkets category = SupportedPredictionMarkets.all,
  }) async {
    try {
      var url = '$_apiBaseUrl/api/v1/predict/markets';
      if (category != SupportedPredictionMarkets.all) {
        url += '?category=${category.name}';
      }

      debugPrint('PredictionApiClient: GET $url');
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        debugPrint(
          'PredictionApiClient: HTTP ${response.statusCode} — '
          '${response.body}',
        );
        return [];
      }

      final List<dynamic> jsonList =
          jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        final map = json as Map<String, dynamic>;
        return _mapToPredictionModel(map);
      }).toList();
    } catch (e) {
      debugPrint('PredictionApiClient: fetchMarkets failed — $e');
      return [];
    }
  }

  /// Fetch a single prediction market by its numeric [id].
  Future<PredictionModel?> fetchMarket(int id) async {
    try {
      final url = '$_apiBaseUrl/api/v1/predict/markets/$id';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      return _mapToPredictionModel(map);
    } catch (e) {
      debugPrint('PredictionApiClient: fetchMarket($id) failed — $e');
      return null;
    }
  }

  /// Fetch YES/NO price history for a market from the API.
  Future<MarketPriceRecord?> fetchPriceHistory(
    int marketId, {
    int days = 30,
  }) async {
    try {
      final url =
          '$_apiBaseUrl/api/v1/predict/markets/$marketId/history?days=$days';
      debugPrint('PredictionApiClient: GET $url');
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final yesList = json['yes_history'] as List<dynamic>;
      final noList = json['no_history'] as List<dynamic>;

      return MarketPriceRecord(
        yesRecord: PredictionPriceRecord(
          id: marketId,
          name: 'YES',
          priceHistory: yesList
              .map(
                (p) => PriceRecord(
                  price: (p['price'] as num).toDouble(),
                  timestamp: p['timestamp'] as String,
                ),
              )
              .toList(),
        ),
        noRecord: PredictionPriceRecord(
          id: marketId,
          name: 'NO',
          priceHistory: noList
              .map(
                (p) => PriceRecord(
                  price: (p['price'] as num).toDouble(),
                  timestamp: p['timestamp'] as String,
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      debugPrint(
        'PredictionApiClient: fetchPriceHistory($marketId) failed — $e',
      );
      return null;
    }
  }

  /// Map a JSON object from the API to a [PredictionModel].
  PredictionModel _mapToPredictionModel(Map<String, dynamic> json) {
    final yesPrice = (json['yes_price'] as num).toDouble();
    final noPrice = (json['no_price'] as num).toDouble();

    return PredictionModel(
      id: json['id'] as int,
      prompt: json['prompt'] as String,
      details: (json['details'] as String?) ?? '',
      marketAddress: (json['market_address'] as String?) ?? '',
      yesTokenAddress: (json['yes_token_address'] as String?) ?? '',
      noTokenAddress: (json['no_token_address'] as String?) ?? '',
      yesName: (json['yes_name'] as String?) ?? 'YES',
      noName: (json['no_name'] as String?) ?? 'NO',
      tradingVolume: (json['trading_volume'] as num?)?.toDouble() ?? 0,
      time: (json['end_date'] as String?) ?? '',
      longTokenPrice: yesPrice,
      shortTokenPrice: noPrice,
      longTokenPercentage: yesPrice * 100,
      shortTokenPercentage: noPrice * 100,
      longTokenPriceUsd: yesPrice,
      shortTokenPriceUsd: noPrice,
      supportedPredictionMarkets:
          _parseCategory((json['category'] as String?) ?? ''),
      resolution: json['resolved'] as bool?,
    );
  }

  SupportedPredictionMarkets _parseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'football':
        return SupportedPredictionMarkets.football;
      case 'basketball':
        return SupportedPredictionMarkets.basketball;
      case 'soccer':
        return SupportedPredictionMarkets.soccer;
      case 'baseball':
        return SupportedPredictionMarkets.baseball;
      case 'hockey':
        return SupportedPredictionMarkets.hockey;
      case 'college':
        return SupportedPredictionMarkets.college;
      case 'voted':
        return SupportedPredictionMarkets.voted;
      case 'exotic':
        return SupportedPredictionMarkets.exotic;
      default:
        return SupportedPredictionMarkets.exotic;
    }
  }
}
