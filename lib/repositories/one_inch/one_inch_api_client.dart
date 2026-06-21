import 'dart:convert';

import 'package:http/http.dart' as http;

/// Client for interacting with the 1inch DEX Aggregator API v6
///
/// Provides methods to fetch swap quotes and transaction data
/// from 1inch across multiple chains.
class OneInchApiClient {
  OneInchApiClient({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  // Use proxy for web to bypass CORS, direct URL for mobile
  static String get _baseUrl {
    // Check if running on web platform
    const isWeb = bool.fromEnvironment('dart.library.html');
    if (isWeb) {
      // Use local proxy that forwards to 1inch API
      return '/api/1inch/swap/v6.0';
    }
    // Mobile/Desktop: use direct API
    return 'https://api.1inch.dev/swap/v6.0';
  }

  /// Fetches a swap quote from 1inch
  ///
  /// [chainId]: The blockchain network ID (137 for Polygon, 42161 for Arbitrum, etc.)
  /// [srcToken]: Source token contract address
  /// [dstToken]: Destination token contract address
  /// [amount]: Amount to swap in wei (as string)
  ///
  /// Returns a Map containing quote data or throws an exception
  Future<Map<String, dynamic>> getQuote({
    required int chainId,
    required String srcToken,
    required String dstToken,
    required String amount,
  }) async {
    final url = Uri.parse('$_baseUrl/$chainId/quote').replace(
      queryParameters: {
        'src': srcToken.toLowerCase(),
        'dst': dstToken.toLowerCase(),
        'amount': amount,
      },
    );

    // ignore: avoid_print
    print('[1inchAPI] Fetching quote: $url');

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // ignore: avoid_print
        print('[1inchAPI] Quote successful: ${data['dstAmount']}');
        return data;
      } else if (response.statusCode == 429) {
        // ignore: avoid_print
        print('[1inchAPI] Rate limit hit (429)');
        throw OneInchRateLimitException();
      } else {
        // ignore: avoid_print
        print(
            '[1inchAPI] Quote failed: ${response.statusCode} - ${response.body}',);
        throw OneInchApiException(
          'Failed to get quote: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is OneInchApiException || e is OneInchRateLimitException) {
        rethrow;
      }
      // ignore: avoid_print
      print('[1inchAPI] Exception: $e');
      throw OneInchApiException('Network error: $e');
    }
  }

  /// Fetches swap transaction data from 1inch
  ///
  /// [chainId]: The blockchain network ID
  /// [srcToken]: Source token contract address
  /// [dstToken]: Destination token contract address
  /// [amount]: Amount to swap in wei (as string)
  /// [from]: User's wallet address
  /// [slippage]: Slippage tolerance in percentage (e.g., 1 for 1%)
  ///
  /// Returns a Map containing transaction data or throws an exception
  Future<Map<String, dynamic>> getSwap({
    required int chainId,
    required String srcToken,
    required String dstToken,
    required String amount,
    required String from,
    double slippage = 1.0,
  }) async {
    final url = Uri.parse('$_baseUrl/$chainId/swap').replace(
      queryParameters: {
        'src': srcToken.toLowerCase(),
        'dst': dstToken.toLowerCase(),
        'amount': amount,
        'from': from.toLowerCase(),
        'slippage': slippage.toString(),
      },
    );

    // ignore: avoid_print
    print('[1inchAPI] Fetching swap: $url');

    try {
      final response = await _httpClient.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        // ignore: avoid_print
        print('[1inchAPI] Swap successful');
        return data;
      } else if (response.statusCode == 429) {
        // ignore: avoid_print
        print('[1inchAPI] Rate limit hit (429)');
        throw OneInchRateLimitException();
      } else {
        // ignore: avoid_print
        print(
            '[1inchAPI] Swap failed: ${response.statusCode} - ${response.body}',);
        throw OneInchApiException(
          'Failed to get swap: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is OneInchApiException || e is OneInchRateLimitException) {
        rethrow;
      }
      // ignore: avoid_print
      print('[1inchAPI] Exception: $e');
      throw OneInchApiException('Network error: $e');
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _httpClient.close();
  }
}

/// Exception thrown when 1inch API returns an error
class OneInchApiException implements Exception {
  OneInchApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'OneInchApiException: $message';
}

/// Exception thrown when rate limit is exceeded
class OneInchRateLimitException implements Exception {
  @override
  String toString() =>
      'OneInchRateLimitException: Rate limit exceeded (1 req/sec on free tier)';
}
