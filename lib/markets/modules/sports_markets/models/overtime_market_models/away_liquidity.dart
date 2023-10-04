class AwayLiquidity {
  const AwayLiquidity({
    required this.positions,
    required this.usd,
  });

  factory AwayLiquidity.fromJson(Map<String, dynamic> json) {
    return AwayLiquidity(
      positions: json['positions'] as double,
      usd: json['usd'] as double,
    );
  }

  static const empty = AwayLiquidity(
    positions: 0,
    usd: 0,
  );

  final double positions;
  final double usd;
}
