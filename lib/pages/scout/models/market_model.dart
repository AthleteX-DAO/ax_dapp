class MarketModel {
  MarketModel({
    required this.marketPrice,
    required double recentPrice,
    required this.bookPrice,
  }) : percentage = recentPrice > 0
            ? (marketPrice - recentPrice) * 100 / recentPrice
            : 0.0;
  final double marketPrice;
  final double percentage;
  final double bookPrice;

  // this purpose of this line is to generate some fake data because we don't
  // have any history of price at the moment
  // this.percentage = new Random().nextDouble() > 0.5 ? new Random().nextDouble
  // () : -1 * new Random().nextDouble();
}
