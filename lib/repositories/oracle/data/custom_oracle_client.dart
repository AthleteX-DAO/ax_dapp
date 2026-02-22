import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:ax_dapp/repositories/oracle/models/price_feed.dart';

/// Pure Dart custom oracle client
/// No Flutter dependencies, no business logic
/// HTTP client for custom price oracle endpoint
class CustomOracleClient {
  CustomOracleClient({
    required String baseUrl,
    String? apiKey,
    this.timeout = const Duration(seconds: 15),
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey {
    print(
      '🔮 [CustomOracleClient] Initializing with endpoint: $_baseUrl',
    );
  }

  final String _baseUrl;
  final String? _apiKey;
  final Duration timeout;
  late final http.Client _httpClient = http.Client();

  /// Fetch price from custom oracle endpoint
  /// 
  /// Expects endpoint to return JSON:
  /// {
  ///   "symbol": "ETH",
  ///   "price": 2543.25,
  ///   "timestamp": 1677600000,
  ///   "source": "custom",
  ///   "decimals": 18,
  ///   "confidence": 0.5
  /// }
  /// 
  /// Parameters:
  ///   - symbol: Asset symbol (e.g., 'ETH', 'BTC')
  /// 
  /// Returns: PriceFeed with price data from custom endpoint
  /// 
  /// Throws: Exception if API call fails or response is invalid
  Future<PriceFeed> getLatestPrice(String symbol) async {
    print('🔮 [CustomOracleClient] Fetching $symbol');

    try {
      // Build URL for the symbol
      final url = Uri.parse('$_baseUrl/price/$symbol');

      print('🔮 [CustomOracleClient] Calling endpoint: $url');

      // Build headers with API key if provided
      final headers = <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      if (_apiKey != null && _apiKey!.isNotEmpty) {
        headers['X-API-Key'] = _apiKey!;
        print('🔮 [CustomOracleClient] Using API key authentication');
      }

      // Make HTTP GET request
      final response = await _httpClient.get(url, headers: headers).timeout(
        timeout,
        onTimeout: () {
          throw Exception(
            '🔮 [CustomOracleClient] Timeout fetching $symbol from $_baseUrl',
          );
        },
      );

      print(
        '🔮 [CustomOracleClient] Got response status: ${response.statusCode}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          '🔮 [CustomOracleClient] HTTP ${response.statusCode} '
          'fetching $symbol: ${response.body}',
        );
      }

      // Parse JSON response
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      print('🔮 [CustomOracleClient] Parsed JSON response');

      // Extract required fields
      final priceValue = jsonData['price'];
      if (priceValue == null) {
        throw Exception(
          '🔮 [CustomOracleClient] Missing price field in response for $symbol',
        );
      }

      final price = (priceValue is num)
          ? priceValue.toDouble()
          : double.parse(priceValue.toString());

      // Extract optional fields with defaults
      final timestamp = (jsonData['timestamp'] as int?) ??
          DateTime.now().millisecondsSinceEpoch;
      final decimals = (jsonData['decimals'] as int?) ?? 18;
      final confidence = (jsonData['confidence'] as num?)?.toDouble();
      final source = jsonData['source'] as String? ?? 'custom';

      if (price == 0.0) {
        throw Exception(
          '🔮 [CustomOracleClient] Invalid price (0.0) for $symbol',
        );
      }

      final now = DateTime.now().millisecondsSinceEpoch;
      final priceAge = ((now - timestamp) / 1000).round();

      print(
        '🔮 [CustomOracleClient] ✓ Fetched $symbol: '
        'price=$price, decimals=$decimals, age=${priceAge}s, source=$source',
      );

      return PriceFeed(
        symbol: symbol,
        price: price,
        decimals: decimals,
        timestamp: timestamp,
        source: PriceFeedSource.custom,
        confidence: confidence,
        rawData: {
          'fullResponse': jsonData,
          'ageSeconds': priceAge,
          'endpoint': _baseUrl,
        },
      );
    } catch (e, stackTrace) {
      print(
        '❌ [CustomOracleClient] Error fetching $symbol: $e',
      );
      developer.log(
        'CustomOracleClient error for $symbol',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch multiple prices in parallel
  Future<List<PriceFeed>> getMultiplePrices(List<String> symbols) async {
    print(
      '🔮 [CustomOracleClient] Fetching ${symbols.length} prices',
    );

    final futures = symbols.map(getLatestPrice);
    return Future.wait(futures);
  }

  /// Health check endpoint
  /// 
  /// Returns: true if endpoint is reachable and responding
  Future<bool> healthCheck() async {
    print('🔮 [CustomOracleClient] Running health check');

    try {
      final url = Uri.parse('$_baseUrl/health');

      final response = await _httpClient.get(url).timeout(
        timeout,
        onTimeout: () => throw Exception('Health check timeout'),
      );

      final isHealthy = response.statusCode == 200;
      print(
        '🔮 [CustomOracleClient] Health check: '
        '${isHealthy ? '✓ OK' : '❌ FAILED'} (${response.statusCode})',
      );

      return isHealthy;
    } catch (e) {
      print(
        '🔮 [CustomOracleClient] Health check failed: $e',
      );
      return false;
    }
  }

  /// Cleanup HTTP client resources
  void dispose() {
    print('🔮 [CustomOracleClient] Disposing HTTP client');
    _httpClient.close();
  }
}
