class MarketModel {
  final double marketPrice;
  final double percentage;

  MarketModel({required double marketPrice, required double recentPrice}) :
    this.marketPrice = marketPrice,
    this.percentage = (marketPrice - recentPrice) * 100 / recentPrice;
}