class HomeLiquidity {
  const HomeLiquidity({
    required this.positions,
    required this.usd,
  });

  factory HomeLiquidity.fromJson(Map<String, dynamic> json) {
    return HomeLiquidity(
      positions: json['positions'] as double,
      usd: json['usd'] as double,
    );
  }

  static const empty = HomeLiquidity(
    positions: 0,
    usd: 0,
  );

  final double positions;
  final double usd;
}
