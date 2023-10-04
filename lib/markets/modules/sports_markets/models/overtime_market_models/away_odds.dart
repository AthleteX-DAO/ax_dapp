class AwayOdds {

  AwayOdds({
    required this.american,
    required this.decimal,
    required this.normalizedImplied,
  });

  factory AwayOdds.fromJson(Map<String, dynamic> json) {
    return AwayOdds(
      american: json['american'] as double,
      decimal: json['decimal'] as double,
      normalizedImplied: json['normalizedImplied'] as double,
    );
  }
  final double american;
  final double decimal;
  final double normalizedImplied;
}
