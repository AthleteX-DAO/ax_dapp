class Athlete {
  final String name;
  final List war;
  final List time;

  const Athlete({required this.name, required this.time, required this.war});

  static Athlete fromJson(json) =>
      Athlete(name: json['name'], time: json['time'], war: json['war']);
}
