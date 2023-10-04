class PriceImpact {

  PriceImpact({
    required this.homePriceImpact,
    required this.awayPriceImpact,
  });

  factory PriceImpact.fromJson(Map<String, dynamic> json) {
    return PriceImpact(
      homePriceImpact: json['homePriceImpact'] as double,
      awayPriceImpact: json['awayPriceImpact'] as double,
    );
  }
  final double homePriceImpact;
  final double awayPriceImpact;
}
