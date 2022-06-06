import 'dart:math';

class MarketModel {
  final double marketPrice;
  final double percentage;

  MarketModel({required double marketPrice, required double recentPrice}) :
    this.marketPrice = marketPrice,
    this.percentage = recentPrice > 0 ? (marketPrice - recentPrice) * 100 / recentPrice : 0.0;
    // this.percentage = new Random().nextDouble() > 0.5 ? new Random().nextDouble() : -1 * new Random().nextDouble();
}