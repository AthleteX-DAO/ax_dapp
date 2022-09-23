class GraphData {
  GraphData(
    this.date,
    this.price, {
    this.longMarketPrice = 0,
    this.shortMarketPrice = 0,
  });

  final DateTime date;
  final double price;
  final double longMarketPrice;
  final double shortMarketPrice;

  @override
  String toString() {
    return '${date.toString()}, $price, $longMarketPrice, $shortMarketPrice';
  }
}
