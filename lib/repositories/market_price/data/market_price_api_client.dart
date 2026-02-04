import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketPriceApiClient {
  MarketPriceApiClient({
    String? baseUrl,
    http.Client? httpClient,
  })  : _baseUrls = baseUrl == null
            ? const [_prodBaseUrl, _emulatorBaseUrl]
            : [baseUrl, _emulatorBaseUrl],
        _httpClient = httpClient ?? http.Client();

  static const String _prodBaseUrl = '/api';
  static const String _emulatorBaseUrl =
      'http://127.0.0.1:5001/athletex-prod/asia-east1/coingeckoProxy';

  final List<String> _baseUrls;
  final http.Client _httpClient;

  Future<List<Map<String, dynamic>>> fetchMarkets({
    required List<String> ids,
    String vsCurrency = 'usd',
  }) async {
    if (ids.isEmpty) return [];

    final idsParam = ids.join(',');
    final response = await _getWithFallback(
      (baseUrl) => Uri.parse(
        '$baseUrl/markets'
        '?vs_currency=$vsCurrency'
        '&ids=$idsParam'
        '&price_change_percentage=1h,24h',
      ),
    );

    final data = jsonDecode(response.body) as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  Future<List<List<dynamic>>> fetchMarketChart({
    required String id,
    String vsCurrency = 'usd',
    int days = 1,
  }) async {
    final response = await _getWithFallback(
      (baseUrl) => Uri.parse(
        '$baseUrl/market_chart'
        '?vs_currency=$vsCurrency'
        '&days=$days'
        '&id=$id',
      ),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final prices = data['prices'] as List<dynamic>;
    return prices.cast<List<dynamic>>();
  }

  void dispose() {
    _httpClient.close();
  }

  Future<http.Response> _getWithFallback(
    Uri Function(String baseUrl) buildUrl,
  ) async {
    Object? lastError;

    for (final baseUrl in _baseUrls) {
      final url = buildUrl(baseUrl);
      try {
        print('[MarketPriceApiClient] Calling: $url');
        final response = await _httpClient.get(url);
        print(
          '[MarketPriceApiClient] Response: ${response.statusCode} - ${response.headers["content-type"]}',
        );

        if (response.statusCode != 200) {
          throw Exception(
            'MarketPriceApiClient: HTTP ${response.statusCode} ${response.body}',
          );
        }

        _ensureJsonResponse(response);
        return response;
      } catch (e) {
        lastError = e;
        if (baseUrl == _prodBaseUrl) {
          print(
            '[MarketPriceApiClient] Prod request failed. Falling back to emulator.',
          );
        } else {
          print('[MarketPriceApiClient] Fallback request failed: $e');
        }
      }
    }

    throw Exception(
      'MarketPriceApiClient: All endpoints failed. Last error: $lastError',
    );
  }

  void _ensureJsonResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      throw Exception(
        'MarketPriceApiClient: Non-JSON response from $contentType. '
        'Is the CoinGecko proxy available?',
      );
    }
  }
}
