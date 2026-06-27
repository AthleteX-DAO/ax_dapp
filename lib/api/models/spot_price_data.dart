class SpotPriceData {
  const SpotPriceData({
    required this.price,
    required this.timestamp,
    required this.marketId,
  });

  factory SpotPriceData.fromJson(Map<String, dynamic> json) {
    return SpotPriceData(
      price: (json['price'] as num).toDouble(),
      timestamp: json['timestamp'] as int? ?? 0,
      marketId: json['market_id'] as int? ?? 0,
    );
  }

  final double price;
  final int timestamp;
  final int marketId;
}
