// ignore_for_file: avoid_positional_boolean_parameters

const kCollateralizationMultiplier = 1000;

class Athlete {
  const Athlete({
    required this.name,
    required this.id,
    required this.team,
    required this.position,
    required this.passingYards,
    required this.passingTouchdowns,
    required this.reception,
    required this.receivingYards,
    required this.receivingTouchdowns,
    required this.rushingYards,
    required this.war,
    required this.scaledPrice,
    required this.time,
  });

  factory Athlete.fromJson(Map<String, dynamic> json) => Athlete(
        name: json['name'] as String,
        id: json['id'] as int,
        team: json['team'] as String,
        position: json['position'] as String,
        passingYards: json['passingYards'] as double,
        passingTouchdowns: json['passingTouchdowns'] as double,
        reception: json['reception'] as double,
        receivingYards: json['receivingYards'] as double,
        receivingTouchdowns: json['receivingTouchdowns'] as double,
        rushingYards: json['rushingYards'] as double,
        time: json['timestamp'] as String,
        war: json['price'] as double,
        scaledPrice: (json['price'] as double) * kCollateralizationMultiplier,
      );

  final String name;
  final int id;
  final String team;
  final String position;
  final double passingYards;
  final double passingTouchdowns;
  final double reception;
  final double receivingYards;
  final double receivingTouchdowns;
  final double rushingYards;
  final double war;
  final double scaledPrice;
  final String time;
}
