class Coin {
  const Coin({
    required this.name,
    required this.ticker,
    required this.price,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        name: json['name'] as String,
        ticker: json['asset_id'] as String,
        price: json['price_usd'] as double,
      );

  final String name;
  final String ticker;
  final double price;
}
