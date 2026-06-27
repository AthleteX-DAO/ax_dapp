import 'dart:convert';

import 'package:ax_dapp/account/data/portfolio_balance_response.dart';
import 'package:ax_dapp/app/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// HTTP client for the ax-server /portfolio endpoints.
///
/// Follows the same pattern as [PredictionApiClient].
class PortfolioApiClient {
  PortfolioApiClient({
    http.Client? httpClient,
    String? apiBaseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _apiBaseUrl = apiBaseUrl ?? baseApiUrl;

  final http.Client _httpClient;
  final String _apiBaseUrl;

  /// Fetch wallet balances + Synthetix account data from the server.
  ///
  /// Returns `null` on any error (timeout, bad response, parse failure).
  Future<PortfolioBalanceResponse?> fetchBalance(String walletAddress) async {
    if (walletAddress.isEmpty) return null;

    try {
      final url =
          '$_apiBaseUrl/api/v1/portfolio/balance?wallet=$walletAddress';
      debugPrint('📊 [PortfolioApiClient] GET $url');

      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        debugPrint(
          '📊 [PortfolioApiClient] HTTP ${response.statusCode}: '
          '${response.body}',
        );
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = PortfolioBalanceResponse.fromJson(json);

      debugPrint(
        '📊 [PortfolioApiClient] OK — '
        'MATIC=${result.maticBalance.toStringAsFixed(4)}, '
        'USDC=\$${result.usdcBalanceUsd.toStringAsFixed(2)}, '
        'accounts=${result.accounts.length}',
      );

      return result;
    } catch (e) {
      debugPrint('❌ [PortfolioApiClient] Error: $e');
      return null;
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
