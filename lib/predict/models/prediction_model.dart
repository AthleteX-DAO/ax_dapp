import 'package:ax_dapp/markets/models/models.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ethereum_api/tokens_api.dart';

class PredictionModel extends MarketModel {
  const PredictionModel({
    required this.id,
    required this.prompt,
    required this.details,
    required this.marketAddress,
    this.resolution,
    required this.supportedPredictionMarkets,
    required this.yesTokenAddress,
    required this.noTokenAddress,
    required this.yesName,
    required this.noName,
    required this.time,
    required this.longTokenPrice,
    required this.shortTokenPrice,
    required this.longTokenPercentage,
    required this.shortTokenPercentage,
    required this.longTokenPriceUsd,
    required this.shortTokenPriceUsd,
  }) : super(
          id: id,
          name: prompt,
          marketHash: marketAddress,
          typeOfMarket: SupportedMarkets.prediction,
        );

  @override
  final int id;

  final String prompt;
  final String details;
  final bool? resolution;
  final String marketAddress;
  final String yesTokenAddress;
  final String noTokenAddress;
  final String yesName;
  final String noName;
  final SupportedPredictionMarkets supportedPredictionMarkets;
  final String time;
  final double? longTokenPrice;
  final double? longTokenPriceUsd;
  final double? shortTokenPrice;
  final double? shortTokenPriceUsd;
  final double? longTokenPercentage;
  final double? shortTokenPercentage;

  static const empty = PredictionModel(
    id: 0,
    prompt: '',
    details: '',
    marketAddress: kEmptyAddress,
    yesTokenAddress: '',
    noTokenAddress: '',
    yesName: '',
    noName: '',
    supportedPredictionMarkets: SupportedPredictionMarkets.all,
    time: '',
    longTokenPrice: 0,
    shortTokenPrice: 0,
    longTokenPercentage: 0,
    shortTokenPercentage: 0,
    longTokenPriceUsd: 0,
    shortTokenPriceUsd: 0,
  );

  @override
  List<Object?> get props => [
        id,
        prompt,
        details,
        marketAddress,
        yesTokenAddress,
        noTokenAddress,
        resolution,
        yesName,
        noName,
        supportedPredictionMarkets,
        time,
        longTokenPrice,
        longTokenPriceUsd,
        shortTokenPrice,
        shortTokenPriceUsd,
        longTokenPercentage,
        shortTokenPercentage,
      ];

  @override
  String toString() =>
      'PredictModel(prompt: $prompt, details: $details, resolution: $resolution)';
}
