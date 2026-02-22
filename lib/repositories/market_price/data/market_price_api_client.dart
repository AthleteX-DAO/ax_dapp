import 'dart:convert';
import 'package:http/http.dart' as http;

/// Direct CoinGecko API client — no Firebase proxy, no emulator fallback.
/// Free tier supports ~10-30 calls/min. Callers should batch IDs and cache.
class MarketPriceApiClient {
  MarketPriceApiClient({
    String? baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl ?? _defaultBaseUrl,
        _httpClient = httpClient ?? http.Client();

  static const String _defaultBaseUrl = 'https://api.coingecko.com/api/v3';

  final String _baseUrl;
  final http.Client _httpClient;

  /// Fetch market data for multiple coin IDs in a single call.
  /// CoinGecko /coins/markets accepts comma-separated IDs.
  Future<List<Map<String, dynamic>>> fetchMarkets({
    required List<String> ids,
    String vsCurrency = 'usd',
  }) async {
    if (ids.isEmpty) return [];

    final idsParam = ids.join(',');
    final url = Uri.parse(
      '$_baseUrl/coins/markets'
      '?vs_currency=$vsCurrency'
      '&ids=$idsParam'
      '&price_change_percentage=1h,24h',
    );

    final response = await _get(url);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  /// Fetch price chart for a single coin (CoinGecko only supports one at a time).
  Future<List<List<dynamic>>> fetchMarketChart({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/coins/$id/market_chart'
      '?vs_currency=$vsCurrency'
      '&days=$days',
    );

    final response = await _get(url);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final prices = data['prices'] as List<dynamic>;
    return prices.cast<List<dynamic>>();
  }

  void dispose() {
    _httpClient.close();
  }

  Future<http.Response> _get(Uri url) async {
    print('[MarketPriceApiClient] GET $url');
    final response = await _httpClient.get(url);
    print(
      '[MarketPriceApiClient] ${response.statusCode} '
      '${response.headers["content-type"]}',
    );

    if (response.statusCode == 429) {
      throw Exception(
        'MarketPriceApiClient: Rate limited (429). '
        'Reduce call frequency or batch more IDs.',
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        'MarketPriceApiClient: HTTP ${response.statusCode} ${response.body}',
      );
    }

    return response;
  }
}
