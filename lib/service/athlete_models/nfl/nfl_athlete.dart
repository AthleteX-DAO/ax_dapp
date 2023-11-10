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
    required double price,
    required String timeStamp,
  }) : super(id, name, team, position, price, timeStamp);

  factory NFLAthlete.fromJson(Map<String, dynamic> json) =>
      _$NFLAthleteFromJson(json);

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

  Map<String, dynamic> toJson() => _$NFLAthleteToJson(this);
}
