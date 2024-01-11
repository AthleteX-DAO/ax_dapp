import 'package:ax_dapp/markets/models/models.dart';

class PredictionMarketModel extends MarketModel {
  const PredictionMarketModel({
    required this.marketPrice,
    required this.recentPrice,
  })  : percentage = recentPrice > 0
            ? (marketPrice - recentPrice) * 100 / recentPrice
            : 0.0,
        super(
          id: 0,
          name: '',
          marketHash: '',
          typeOfMarket: SupportedMarkets.prediction,
        );

  final double marketPrice;
  final double percentage;
  final double recentPrice;
  @override
  List<Object?> get props => [
        marketPrice,
        percentage,
        recentPrice,
      ];
}
