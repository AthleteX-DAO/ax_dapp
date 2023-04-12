import 'package:ax_dapp/service/athlete_models/sport_athlete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nfl_athlete.g.dart';

@JsonSerializable()
class NFLAthlete extends SportAthlete {
  const NFLAthlete({
    required int id,
    required String name,
    required String team,
    required String position,
    required this.passingYards,
    required this.passingTouchdowns,
    required this.reception,
    required this.receivingYards,
    required this.receivingTouchdowns,
    required this.rushingYards,
    required this.offensiveSnapsPlayed,
    required this.defensiveSnapsPlayed,
    required double price,
    required String timeStamp,
  }) : super(id, name, team, position, price, timeStamp);

  // ignore: prefer_constructors_over_static_methods
  static NFLAthlete fromJson(Map<String, dynamic> json) {
    return NFLAthlete(
      id: json['ID'] as int,
      name: json['Name'] as String,
      team: json['Team'] as String,
      position: json['Position'] as String,
      passingYards: (json['PassingYards'] as num).toDouble(),
      passingTouchdowns: (json['PassingTouchdowns'] as num).toDouble(),
      reception: (json['Receptions'] as num).toDouble(),
      receivingYards: (json['ReceivingYards'] as num).toDouble(),
      receivingTouchdowns: (json['ReceivingTouchdowns'] as num).toDouble(),
      rushingYards: (json['RushingYards'] as num).toDouble(),
      offensiveSnapsPlayed:
          // (json['OffensiveSnapsPlayed'] as num ?? 0).toDouble(),
          0,
      defensiveSnapsPlayed:
          // (json['DefensiveSnapsPlayed'] as num ?? 0).toDouble(),
          0,
      price: (json['BookPrice'] as num).toDouble(),
      timeStamp: json['Time'] as String,
    );
  }

  // ignore: prefer_constructors_over_static_methods
  static NFLAthlete fromPartialJson(Map<String, dynamic> json) {
    return NFLAthlete(
      id: json['ID'] as int,
      team: json['Team'] as String,
      name: json['Name'] as String,
      position: json['Position'] as String,
      passingYards: (json['PassingYards'] as num).toDouble(),
      rushingYards: (json['RushingYards'] as num).toDouble(),
      reception: (json['Receptions'] as num).toDouble(),
      receivingYards: (json['ReceivingYards'] as num).toDouble(),
      receivingTouchdowns: (json['ReceivingTouchdowns'] as num).toDouble(),
      passingTouchdowns: (json['PassingTouchdowns'] as num).toDouble(),
      offensiveSnapsPlayed: 0,
      defensiveSnapsPlayed: 0,
      price: (json['BookPrice'] as num).toDouble(),
      timeStamp: json['Time'] as String,
    );
  }

  @JsonKey(name: 'passingYards')
  final double passingYards;
  @JsonKey(name: 'passingTouchdowns')
  final double passingTouchdowns;
  @JsonKey(name: 'reception')
  final double reception;
  @JsonKey(name: 'receivingYards')
  final double receivingYards;
  @JsonKey(name: 'receivingTouchdowns')
  final double receivingTouchdowns;
  @JsonKey(name: 'rushingYards')
  final double rushingYards;
  @JsonKey(name: 'offensiveSnapsPlayed')
  final double offensiveSnapsPlayed;
  @JsonKey(name: 'defensiveSnapsPlayed')
  final double defensiveSnapsPlayed;

  Map<String, dynamic> toJson() => _$NFLAthleteToJson(this);
}
