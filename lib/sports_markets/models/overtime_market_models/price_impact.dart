class PriceImpact {
  const PriceImpact({
    required this.homePriceImpact,
    required this.awayPriceImpact,
  });

  factory PriceImpact.fromJson(Map<String, dynamic> json) {
    return PriceImpact(
      homePriceImpact: json['homePriceImpact'] as double,
      awayPriceImpact: json['awayPriceImpact'] as double,
    );
  }

  static const empty = PriceImpact(
    homePriceImpact: 0,
    awayPriceImpact: 0,
  );

  final double homePriceImpact;
  final double awayPriceImpact;
}
