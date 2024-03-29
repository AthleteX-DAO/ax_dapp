import 'package:ax_dapp/markets/models/models.dart';

class TokenMarketModel extends MarketModel {
  const TokenMarketModel({
    required this.marketPrice,
    required this.bookPrice,
    required this.recentPrice,
  })  : percentage = recentPrice > 0
            ? (marketPrice - recentPrice) * 100 / recentPrice
            : 0.0,
        super(
          id: 0,
          name: '',
          marketHash: '',
          typeOfMarket: SupportedMarkets.athlete,
        );

  final double marketPrice;
  final double percentage;
  final double recentPrice;
  final double bookPrice;

  @override
  List<Object?> get props => [
        marketPrice,
        bookPrice,
        recentPrice,
      ];
}
