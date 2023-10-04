class AwayLiquidity {

  AwayLiquidity({
    required this.positions,
    required this.usd,
  });

  factory AwayLiquidity.fromJson(Map<String, dynamic> json) {
    return AwayLiquidity(
      positions: json['positions'] as double,
      usd: json['usd'] as double,
    );
  }
  final double positions;
  final double usd;
}
