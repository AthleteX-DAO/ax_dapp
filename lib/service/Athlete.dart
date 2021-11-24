class Athlete {
  final String name;
  final String team;
  final String position;
  final List passingYards;
  final List passingTouchDowns;
  final List reception;
  final List receiveYards;
  final List receiveTouch;
  final List rushingYards;
  final List war;
  final List time;

  const Athlete({
    required this.name,
    required this.team,
    required this.position,
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
    required this.rushingYards,
    required this.war,
    required this.time,
  });

  static Athlete fromJson(json) =>
      Athlete(
        name: json['name'],
        team: json['team'],
        position: json['position'],
        passingYards: json['passingYards'],
        passingTouchDowns: json['passingTouchdowns'],
        reception: json['reception'],
        receiveYards: json['receiveYards'],
        receiveTouch: json['receiveTouch'],
        rushingYards: json['rushingYards'],
        time: json['time'],
        war: json['price']
      );
}
