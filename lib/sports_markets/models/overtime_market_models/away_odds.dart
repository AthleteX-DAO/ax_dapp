class AwayOdds {
  const AwayOdds({
    required this.american,
    required this.decimal,
    required this.normalizedImplied,
  });

  factory AwayOdds.fromJson(Map<String, dynamic> json) {
    return AwayOdds(
      american: json['american'] == null ? 0.0 : json['american'] as double,
      decimal: json['decimal'] == null ? 0.0 : json['decimal'] as double,
      normalizedImplied: json['normalizedImplied'] == null
          ? 0.0
          : json['normalizedImplied'] as double,
    );
  }

  static const empty = AwayOdds(
    american: 0,
    decimal: 0,
    normalizedImplied: 0,
  );

  final double? american;
  final double? decimal;
  final double? normalizedImplied;
}
