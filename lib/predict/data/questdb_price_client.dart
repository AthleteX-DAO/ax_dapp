import 'package:ax_dapp/predict/models/market_price_record.dart';
import 'package:ax_dapp/service/prediction_models/prediction_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Data-layer client for fetching price history from QuestDB
/// NO business logic — raw HTTP calls only (Data Layer).
class QuestDBPriceClient {
  QuestDBPriceClient({
    String questdbUrl = 'http://localhost:9000',
  }) : _questdbUrl = questdbUrl;

  final String _questdbUrl;

  /// Fetch YES token price history for a market from QuestDB.
  /// Returns list of {timestamp: ISO8601, price: double} records
  Future<List<PriceRecord>> getYesPriceHistory(
    String marketAddress,
    DateTime startDate,
  ) async {
    final query = '''
      SELECT timestamp, price FROM prediction_prices 
      WHERE market = '$marketAddress' 
      AND token = 'YES' 
      AND timestamp >= cast('$startDate' as timestamp)
      ORDER BY timestamp ASC
    ''';
    return _executeQuery(query);
  }

  /// Fetch NO token price history for a market from QuestDB.
  Future<List<PriceRecord>> getNoPriceHistory(
    String marketAddress,
    DateTime startDate,
  ) async {
    final query = '''
      SELECT timestamp, price FROM prediction_prices 
      WHERE market = '$marketAddress' 
      AND token = 'NO' 
      AND timestamp >= cast('$startDate' as timestamp)
      ORDER BY timestamp ASC
    ''';
    return _executeQuery(query);
  }

  /// Fetch complete market price history for YES and NO tokens
  Future<MarketPriceRecord> getMarketPriceHistory(
    String marketAddress,
    DateTime startDate,
    int marketId,
  ) async {
    try {
      final yesHistory = await getYesPriceHistory(marketAddress, startDate);
      final noHistory = await getNoPriceHistory(marketAddress, startDate);

      return MarketPriceRecord(
        yesRecord: PredictionPriceRecord(
          id: marketId,
          name: 'YES',
          priceHistory: yesHistory,
        ),
        noRecord: PredictionPriceRecord(
          id: marketId,
          name: 'NO',
          priceHistory: noHistory,
        ),
      );
    } catch (e) {
      debugPrint('Error fetching market price history from QuestDB: $e');
      // Return empty records so UI still renders
      return MarketPriceRecord(
        yesRecord: PredictionPriceRecord(
          id: marketId,
          name: 'YES',
          priceHistory: [],
        ),
        noRecord: PredictionPriceRecord(
          id: marketId,
          name: 'NO',
          priceHistory: [],
        ),
      );
    }
  }

  /// Execute a QuestDB HTTP query and parse results
  Future<List<PriceRecord>> _executeQuery(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_questdbUrl/exec?query=${Uri.encodeComponent(query)}'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('QuestDB query failed: ${response.statusCode}');
      }

      // Parse QuestDB CSV response format
      final lines = response.body.split('\n');
      if (lines.length < 2) return [];

      final results = <PriceRecord>[];
      // Skip header line
      for (var i = 1; i < lines.length; i++) {
        if (lines[i].trim().isEmpty) continue;

        final parts = lines[i].split(',');
        if (parts.length >= 2) {
          try {
            results.add(
              PriceRecord(
                timestamp: parts[0].trim(),
                price: double.parse(parts[1].trim()),
              ),
            );
          } catch (e) {
            debugPrint('Failed to parse price record: ${lines[i]}');
          }
        }
      }

      return results;
    } catch (e) {
      debugPrint('QuestDB query execution failed: $e');
      return [];
    }
  }
}
