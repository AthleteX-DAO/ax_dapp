class Coin {
  final String name;
  final String ticker;
  final double price;

  const Coin({
    required this.name,
    required this.ticker,
    required this.price,
  });

  static Coin fromJson(json) => Coin(
        name: json['name'],
        ticker: json['asset_id'],
        price: json['price_usd'],
      );
}
