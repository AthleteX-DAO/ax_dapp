class HomeOdds {

  HomeOdds({
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
  final double american;
  final double decimal;
  final double normalizedImplied;
}
