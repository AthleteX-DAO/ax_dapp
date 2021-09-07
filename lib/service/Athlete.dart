class Athlete {
  final String name;
  final List history;

  const Athlete({required this.name, required this.history});

  static Athlete fromJson(json) =>
      Athlete(name: json['name'], history: json['history']);
}
