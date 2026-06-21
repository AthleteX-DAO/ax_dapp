import 'dart:convert';

import 'package:ax_dapp/app/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Unsigned transaction from the API.
class UnsignedTransaction {
  const UnsignedTransaction({
    required this.to,
    required this.data,
    required this.value,
    required this.gasEstimate,
    required this.description,
  });

  factory UnsignedTransaction.fromJson(Map<String, dynamic> json) {
    return UnsignedTransaction(
      to: json['to'] as String,
      data: json['data'] as String,
      value: json['value'] as String? ?? '0',
      gasEstimate: json['gas_estimate'] as int? ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  final String to;
  final String data;
  final String value;
  final int gasEstimate;
  final String description;
}

/// Response from a predict order build endpoint.
class PredictOrderResponse {
  const PredictOrderResponse({
    required this.transactions,
    required this.chainId,
  });

  factory PredictOrderResponse.fromJson(Map<String, dynamic> json) {
    final txList = json['transactions'] as List<dynamic>;
    return PredictOrderResponse(
      transactions: txList
          .map((t) => UnsignedTransaction.fromJson(t as Map<String, dynamic>))
          .toList(),
      chainId: json['chain_id'] as int,
    );
  }

  final List<UnsignedTransaction> transactions;
  final int chainId;
}

/// Quote response from the predict orders API.
class PredictQuote {
  const PredictQuote({
    required this.amountIn,
    required this.amountOut,
    required this.priceImpact,
    required this.path,
  });

  factory PredictQuote.fromJson(Map<String, dynamic> json) {
    return PredictQuote(
      amountIn: json['amount_in'] as String,
      amountOut: json['amount_out'] as String,
      priceImpact: (json['price_impact'] as num?)?.toDouble() ?? 0,
      path: (json['path'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  final String amountIn;
  final String amountOut;
  final double priceImpact;
  final List<String> path;
}

/// HTTP client for prediction market order building via ax-server.
///
/// The server builds unsigned transactions; the client signs and sends them
/// locally using the user's wallet credentials.
class PredictionOrderClient {
  PredictionOrderClient({
    http.Client? httpClient,
    String? apiBaseUrl,
  })  : _httpClient = httpClient ?? http.Client(),
        _apiBaseUrl = apiBaseUrl ?? baseApiUrl;

  final http.Client _httpClient;
  final String _apiBaseUrl;

  /// Build unsigned transactions to buy YES or NO tokens.
  Future<PredictOrderResponse?> buildBuyOrder({
    required String marketId,
    required String outcome,
    required String axusdAmountWei,
    required String wallet,
    int slippageBps = 100,
  }) async {
    return _postOrder('/api/v1/predict/orders/build-buy', {
      'market_id': marketId,
      'outcome': outcome,
      'axusd_amount': axusdAmountWei,
      'wallet': wallet,
      'slippage_bps': slippageBps,
    });
  }

  /// Build unsigned transactions to sell YES or NO tokens for axUSD.
  Future<PredictOrderResponse?> buildSellOrder({
    required String marketId,
    required String outcome,
    required String tokenAmountWei,
    required String wallet,
    int slippageBps = 100,
  }) async {
    return _postOrder('/api/v1/predict/orders/build-sell', {
      'market_id': marketId,
      'outcome': outcome,
      'token_amount': tokenAmountWei,
      'wallet': wallet,
      'slippage_bps': slippageBps,
    });
  }

  /// Build unsigned transaction to mint YES+NO tokens by depositing axUSD.
  Future<PredictOrderResponse?> buildMintOrder({
    required String marketId,
    required String axusdAmountWei,
    required String wallet,
  }) async {
    return _postOrder('/api/v1/predict/orders/build-mint', {
      'market_id': marketId,
      'axusd_amount': axusdAmountWei,
      'wallet': wallet,
    });
  }

  /// Build unsigned transaction to redeem equal YES+NO tokens for axUSD.
  Future<PredictOrderResponse?> buildRedeemOrder({
    required String marketId,
    required String tokenAmountWei,
    required String wallet,
  }) async {
    return _postOrder('/api/v1/predict/orders/build-redeem', {
      'market_id': marketId,
      'token_amount': tokenAmountWei,
      'wallet': wallet,
    });
  }

  /// Get expected output for a swap.
  Future<PredictQuote?> getQuote({
    required String marketId,
    required String outcome,
    required String amountWei,
    required String side,
  }) async {
    try {
      final url = '$_apiBaseUrl/api/v1/predict/orders/quote'
          '?market_id=$marketId&outcome=$outcome'
          '&amount=$amountWei&side=$side';

      final response = await _httpClient
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PredictQuote.fromJson(json);
    } catch (e) {
      debugPrint('PredictionOrderClient: getQuote failed — $e');
      return null;
    }
  }

  Future<PredictOrderResponse?> _postOrder(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = '$_apiBaseUrl$path';
      debugPrint('PredictionOrderClient: POST $url');

      final response = await _httpClient
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        debugPrint(
          'PredictionOrderClient: HTTP ${response.statusCode} — '
          '${response.body}',
        );
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PredictOrderResponse.fromJson(json);
    } catch (e) {
      debugPrint('PredictionOrderClient: $path failed — $e');
      return null;
    }
  }
}
