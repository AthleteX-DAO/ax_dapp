import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

class MarketModel extends Equatable {
  const MarketModel({
    required this.id,
    required this.name,
    required this.typeOfMarket,
    required this.marketPrice,
    required double recentPrice,
    required this.bookPrice,
  }) : percentage = recentPrice > 0
            ? (marketPrice - recentPrice) * 100 / recentPrice
            : 0.0;

  final int id;
  final String name;
  final SupportedMarkets typeOfMarket;
  final double marketPrice;
  final double percentage;
  final double bookPrice;

  @override
  List<Object?> get props => [
        marketPrice,
        percentage,
        bookPrice,
      ];

  // this purpose of this line is to generate some fake data because we don't
  // have any history of price at the moment
  // this.percentage = new Random().nextDouble() > 0.5 ? new Random().nextDouble
  // () : -1 * new Random().nextDouble();
}
