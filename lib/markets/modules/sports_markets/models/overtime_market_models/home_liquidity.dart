class HomeLiquidity {

  HomeLiquidity({
    required this.positions,
    required this.usd,
  });

  factory HomeLiquidity.fromJson(Map<String, dynamic> json) {
    return HomeLiquidity(
      positions: json['positions'] as double,
      usd: json['usd'] as double,
    );
  }
  final double positions;
  final double usd;
}
