import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// Parsed representation of a single deployed prediction market contract
/// from the on-chain manifest JSON.
class DeployedMarketConfig {
  const DeployedMarketConfig({
    required this.pairName,
    required this.question,
    required this.category,
    required this.details,
    required this.resolveBy,
    required this.contractAddress,
    required this.longTokenAddress,
    required this.shortTokenAddress,
    required this.longTokenName,
    required this.shortTokenName,
    required this.feeRecipient,
    required this.protocolFeeRate,
    required this.proposerReward,
  });

  factory DeployedMarketConfig.fromJson(Map<String, dynamic> json) {
    return DeployedMarketConfig(
      pairName: json['pairName'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
      details: json['details'] as String,
      resolveBy: json['resolveBy'] as String,
      contractAddress: json['contractAddress'] as String,
      longTokenAddress: json['longTokenAddress'] as String,
      shortTokenAddress: json['shortTokenAddress'] as String,
      longTokenName: json['longTokenName'] as String,
      shortTokenName: json['shortTokenName'] as String,
      feeRecipient: json['feeRecipient'] as String,
      protocolFeeRate: json['protocolFeeRate'] as String,
      proposerReward: json['proposerReward'] as String,
    );
  }

  final String pairName;
  final String question;
  final String category;
  final String details;
  final String resolveBy;
  final String contractAddress;
  final String longTokenAddress;
  final String shortTokenAddress;
  final String longTokenName;
  final String shortTokenName;
  final String feeRecipient;
  final String protocolFeeRate;
  final String proposerReward;
}

/// Top-level manifest describing all deployed prediction market contracts
/// and shared protocol addresses on a given network.
class PredictionMarketManifest {
  const PredictionMarketManifest({
    required this.network,
    required this.chainId,
    required this.axUSD,
    required this.umaFinder,
    required this.ioo,
    required this.feeRecipient,
    required this.deployedAt,
    required this.markets,
  });

  factory PredictionMarketManifest.fromJson(Map<String, dynamic> json) {
    final marketsJson = json['markets'] as List<dynamic>;
    return PredictionMarketManifest(
      network: json['network'] as String,
      chainId: json['chainId'] as int,
      axUSD: json['axUSD'] as String,
      umaFinder: json['umaFinder'] as String,
      ioo: json['ioo'] as String,
      feeRecipient: json['feeRecipient'] as String,
      deployedAt: json['deployedAt'] as String,
      markets: marketsJson
          .map(
            (e) =>
                DeployedMarketConfig.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String network;
  final int chainId;
  final String axUSD;
  final String umaFinder;
  final String ioo;
  final String feeRecipient;
  final String deployedAt;
  final List<DeployedMarketConfig> markets;

  /// Load the manifest from the bundled asset file.
  static Future<PredictionMarketManifest> loadFromAssets() async {
    final jsonString =
        await rootBundle.loadString('assets/prediction_markets.json');
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return PredictionMarketManifest.fromJson(json);
  }
}
