import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:ax_dapp/repositories/oracle/config/oracle_config.dart';
import 'package:ax_dapp/repositories/oracle/models/price_feed.dart';

/// Pure Dart Pyth oracle client
/// No Flutter dependencies, no business logic
/// Calls Pyth wrapper contract or API for price data
class PythOracleClient {
  PythOracleClient({
    this.pythApiUrl = 'https://hermes.pyth.network',
    this.timeout = const Duration(seconds: 30),
  }) {
    print(
      '🐍 [PythOracleClient] Initializing with API: $pythApiUrl',
    );
  }

  final String pythApiUrl;
  final Duration timeout;
  late final http.Client _httpClient = http.Client();

  /// Fetch latest price from Pyth API
  /// 
  /// Parameters:
  ///   - symbol: Asset symbol (e.g., 'ETH', 'BTC')
  ///   - pythFeedId: Pyth feed ID (32-byte hex string)
  /// 
  /// Returns: PriceFeed with latest price, confidence, and Pyth metadata
  /// 
  /// Throws: Exception if API call fails or data is invalid
  Future<PriceFeed> getLatestPrice(
    String symbol,
    String pythFeedId,
  ) async {
    print(
      '🐍 [PythOracleClient] Fetching $symbol with feed ID: '
      '${pythFeedId.substring(0, 10)}...',
    );

    try {
      // Remove 0x prefix if present
      final cleanFeedId = pythFeedId.startsWith('0x')
          ? pythFeedId.substring(2)
          : pythFeedId;

      // Call Pyth API: /api/latest_price_feeds?ids=[...]
      // Note: Pyth API expects array format for IDs
      final url = Uri.parse(
        '$pythApiUrl/api/latest_price_feeds?ids=[$cleanFeedId]',
      );

      print('🐍 [PythOracleClient] Calling Pyth API: $url');

      final response = await _httpClient.get(url).timeout(
        timeout,
        onTimeout: () {
          throw Exception(
            '🐍 [PythOracleClient] Timeout fetching price for $symbol',
          );
        },
      );

      print(
        '🐍 [PythOracleClient] Got response status: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          '🐍 [PythOracleClient] HTTP ${response.statusCode} '
          'fetching $symbol: ${response.body}',
        );
      }

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      print('🐍 [PythOracleClient] Parsed JSON response');

      // Extract price feed data
      final priceFeeds = jsonData['result']?['price_feeds'] as List?;
      if (priceFeeds == null || priceFeeds.isEmpty) {
        throw Exception(
          '🐍 [PythOracleClient] No price feeds in response for $symbol',
        );
      }

      final priceFeedData = priceFeeds[0] as Map<String, dynamic>;
      final priceData = priceFeedData['price'] as Map<String, dynamic>;

      // Parse price components
      // Pyth returns price as: price = value * 10^exponent
      // Values may be strings or ints depending on API response format
      final priceRaw = priceData['price'];
      final priceValue = priceRaw is String ? int.parse(priceRaw) : priceRaw as int? ?? 0;
      
      final exponentRaw = priceData['expo'];
      final priceExponent = exponentRaw is String ? int.parse(exponentRaw) : exponentRaw as int? ?? -8;
      
      final confRaw = priceData['conf'];
      final confidence = confRaw is String ? int.parse(confRaw) : confRaw as int? ?? 0;
      
      final timeRaw = priceData['publish_time'];
      final publishTime = timeRaw is String ? int.parse(timeRaw) : timeRaw as int? ?? 0;

      // Convert to decimal form: price = value * 10^exponent
      final price = _convertPythPrice(priceValue, priceExponent);
      final confidenceDouble = _convertPythPrice(confidence, priceExponent);

      if (price == 0.0) {
        throw Exception(
          '🐍 [PythOracleClient] Invalid price (0.0) for $symbol',
        );
      }

      final timestamp = publishTime * 1000; // Convert to milliseconds
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final priceAge = now - publishTime;

      print(
        '🐍 [PythOracleClient] ✓ Fetched $symbol: '
        'price=$price, confidence=$confidenceDouble, age=${priceAge}s',
      );

      return PriceFeed(
        symbol: symbol,
        price: price,
        decimals: OracleConfig.pythDecimalPlaces,
        timestamp: timestamp,
        source: PriceFeedSource.pyth,
        confidence: confidenceDouble,
        rawData: {
          'feedId': pythFeedId,
          'price': priceValue,
          'exponent': priceExponent,
          'confidence': confidence,
          'publishTime': publishTime,
          'ageSeconds': priceAge,
          'fullResponse': priceFeedData,
        },
      );
    } catch (e, stackTrace) {
      print(
        '❌ [PythOracleClient] Error fetching $symbol: $e',
      );
      developer.log(
        'PythOracleClient error for $symbol',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch multiple prices in parallel
  Future<List<PriceFeed>> getMultiplePrices(
    Map<String, String> symbolFeedIdPairs,
  ) async {
    print(
      '🐍 [PythOracleClient] Fetching ${symbolFeedIdPairs.length} prices',
    );

    final futures = symbolFeedIdPairs.entries.map(
      (entry) => getLatestPrice(entry.key, entry.value),
    );

    return Future.wait(futures);
  }

  /// Convert Pyth price from (value, exponent) to decimal
  /// Formula: price = value * 10^exponent
  double _convertPythPrice(int value, int exponent) {
    if (value == 0) return 0;

    final absValue = value.abs();
    final isNegative = value < 0;

    if (exponent >= 0) {
      // Multiply by 10^exponent
      final result = absValue * (10 * exponent).toDouble();
      return isNegative ? -result : result;
    } else {
      // Divide by 10^(-exponent)
      final divisor = 10.0 * (-exponent).toDouble();
      final result = absValue / divisor;
      return isNegative ? -result : result;
    }
  }

  /// Cleanup HTTP client resources
  void dispose() {
    print('🐍 [PythOracleClient] Disposing HTTP client');
    _httpClient.close();
  }
}
