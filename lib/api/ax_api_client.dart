import 'dart:convert';

import 'package:ax_dapp/api/models/account_collateral_data.dart';
import 'package:ax_dapp/api/models/account_debt_data.dart';
import 'package:ax_dapp/api/models/pool_info.dart';
import 'package:ax_dapp/api/models/spot_market_info.dart';
import 'package:ax_dapp/api/models/spot_price_data.dart';
import 'package:ax_dapp/api/models/spot_quote_data.dart';
import 'package:ax_dapp/api/models/unsigned_tx_response.dart';
import 'package:ax_dapp/app/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Central HTTP client for all ax-server API interactions.
///
/// Follows the same pattern as [PredictionApiClient].
/// Uses [baseApiUrl] from app_config.dart.
class AxApiClient {
  AxApiClient({
    http.Client? httpClient,
    String? apiBaseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _apiBaseUrl = apiBaseUrl ?? baseApiUrl;

  final http.Client _httpClient;
  final String _apiBaseUrl;

  // ── Spot Market Reads ──────────────────────────────────────────────

  /// Fetch all spot markets.
  Future<List<SpotMarketInfo>> fetchSpotMarkets() async {
    try {
      final url = '$_apiBaseUrl/api/v1/spot/markets';
      debugPrint('🔷 [AxApiClient] GET $url');
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return [];
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = json['items'] as List<dynamic>? ?? [];
      return items
          .map((e) => SpotMarketInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchSpotMarkets failed: $e');
      return [];
    }
  }

  /// Fetch price for a single spot market.
  Future<SpotPriceData?> fetchSpotPrice(int marketId) async {
    try {
      final url = '$_apiBaseUrl/api/v1/spot/markets/$marketId/price';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SpotPriceData.fromJson(json);
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchSpotPrice($marketId) failed: $e');
      return null;
    }
  }

  /// Fetch all market prices in a single batch call.
  Future<Map<int, SpotPriceData>> fetchBatchPrices() async {
    try {
      final url = '$_apiBaseUrl/api/v1/spot/markets/prices';
      debugPrint('🔷 [AxApiClient] GET $url');
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return {};
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final prices = json['prices'] as Map<String, dynamic>? ?? {};
      final result = <int, SpotPriceData>{};
      prices.forEach((key, value) {
        final mid = int.tryParse(key);
        if (mid != null && value is Map<String, dynamic>) {
          result[mid] = SpotPriceData(
            marketId: mid,
            price: double.tryParse(value['price']?.toString() ?? '0') ?? 0,
            timestamp: value['timestamp'] as int? ?? 0,
          );
        }
      });
      return result;
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchBatchPrices failed: $e');
      return {};
    }
  }

  /// Fetch quote for buying or selling on a spot market.
  Future<SpotQuoteData?> fetchSpotQuote({
    required int marketId,
    required String amount,
    required String side,
  }) async {
    try {
      final url =
          '$_apiBaseUrl/api/v1/spot/markets/$marketId/quote?amount=$amount&side=$side';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SpotQuoteData.fromJson(json);
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchSpotQuote failed: $e');
      return null;
    }
  }

  // ── Vault/Earn Reads ───────────────────────────────────────────────

  /// Fetch available pools.
  Future<List<PoolInfo>> fetchPools() async {
    try {
      final url = '$_apiBaseUrl/api/v1/vaults/pools';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return [];
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      return jsonList
          .map((e) => PoolInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchPools failed: $e');
      return [];
    }
  }

  /// Fetch collateral price for a token.
  Future<double?> fetchCollateralPrice(String tokenAddress) async {
    try {
      final url = '$_apiBaseUrl/api/v1/vaults/collateral-price/$tokenAddress';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return (json['price_usd'] as num?)?.toDouble();
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchCollateralPrice failed: $e');
      return null;
    }
  }

  /// Fetch account collateral state.
  Future<AccountCollateralData?> fetchAccountCollateral(int accountId) async {
    try {
      final url = '$_apiBaseUrl/api/v1/vaults/account/$accountId';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AccountCollateralData.fromJson(json);
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchAccountCollateral failed: $e');
      return null;
    }
  }

  /// Fetch account debt and c-ratio.
  Future<AccountDebtData?> fetchAccountDebt({
    required int accountId,
    required int poolId,
    required String collateral,
  }) async {
    try {
      final url =
          '$_apiBaseUrl/api/v1/vaults/account/$accountId/debt?pool_id=$poolId&collateral=$collateral';
      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AccountDebtData.fromJson(json);
    } catch (e) {
      debugPrint('❌ [AxApiClient] fetchAccountDebt failed: $e');
      return null;
    }
  }

  // ── Unsigned TX Builders ───────────────────────────────────────────

  /// Build an ERC-20 approve transaction.
  Future<UnsignedTxResponse?> buildApprove({
    required String tokenAddress,
    required String spender,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-approve', {
      'token_address': tokenAddress,
      'spender': spender,
      'amount': amount,
      'wallet': wallet,
    });
  }

  /// Build a spot market buy transaction.
  Future<UnsignedTxResponse?> buildBuy({
    required int marketId,
    required String usdAmount,
    String minReceived = '0',
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-buy', {
      'market_id': marketId,
      'usd_amount': usdAmount,
      'min_received': minReceived,
      'wallet': wallet,
    });
  }

  /// Build a spot market sell transaction.
  Future<UnsignedTxResponse?> buildSell({
    required int marketId,
    required String synthAmount,
    String minReceived = '0',
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-sell', {
      'market_id': marketId,
      'synth_amount': synthAmount,
      'min_received': minReceived,
      'wallet': wallet,
    });
  }

  /// Build a deposit collateral transaction.
  Future<UnsignedTxResponse?> buildDeposit({
    required int accountId,
    required String collateralType,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-deposit', {
      'account_id': accountId,
      'collateral_type': collateralType,
      'amount': amount,
      'wallet': wallet,
    });
  }

  /// Build a withdraw collateral transaction.
  Future<UnsignedTxResponse?> buildWithdraw({
    required int accountId,
    required String collateralType,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-withdraw', {
      'account_id': accountId,
      'collateral_type': collateralType,
      'amount': amount,
      'wallet': wallet,
    });
  }

  /// Build a delegate collateral transaction.
  Future<UnsignedTxResponse?> buildDelegate({
    required int accountId,
    required int poolId,
    required String collateralType,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-delegate', {
      'account_id': accountId,
      'pool_id': poolId,
      'collateral_type': collateralType,
      'amount': amount,
      'wallet': wallet,
    });
  }

  /// Build a mint axUSD transaction.
  Future<UnsignedTxResponse?> buildMintUsd({
    required int accountId,
    required int poolId,
    required String collateralType,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-mint-usd', {
      'account_id': accountId,
      'pool_id': poolId,
      'collateral_type': collateralType,
      'amount': amount,
      'wallet': wallet,
    });
  }

  /// Build a burn axUSD transaction.
  Future<UnsignedTxResponse?> buildBurnUsd({
    required int accountId,
    required int poolId,
    required String collateralType,
    required String amount,
    required String wallet,
  }) async {
    return _postBuild('/api/v1/orders/build-burn-usd', {
      'account_id': accountId,
      'pool_id': poolId,
      'collateral_type': collateralType,
      'amount': amount,
      'wallet': wallet,
    });
  }

  // ── Internal ───────────────────────────────────────────────────────

  /// POST to a build-* endpoint and parse the UnsignedTxResponse.
  Future<UnsignedTxResponse?> _postBuild(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '$_apiBaseUrl$path';
      debugPrint('🔷 [AxApiClient] POST $url');
      final response = await _httpClient
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        debugPrint(
          '❌ [AxApiClient] POST $path failed: '
          'HTTP ${response.statusCode} — ${response.body}',
        );
        return null;
      }
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UnsignedTxResponse.fromJson(json);
    } catch (e) {
      debugPrint('❌ [AxApiClient] POST $path error: $e');
      return null;
    }
  }

  void dispose() {
    _httpClient.close();
  }
}
