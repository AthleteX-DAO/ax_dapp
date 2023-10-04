class HomeOdds {
  const HomeOdds({
    required this.american,
    required this.decimal,
    required this.normalizedImplied,
  });

  factory HomeOdds.fromJson(Map<String, dynamic> json) {
    return HomeOdds(
      american: json['american'] as double,
      decimal: json['decimal'] as double,
      normalizedImplied: json['normalizedImplied'] as double,
    );
  }

  static const empty = HomeOdds(
    american: 0,
    decimal: 0,
    normalizedImplied: 0,
  );

  final double american;
  final double decimal;
  final double normalizedImplied;
}
