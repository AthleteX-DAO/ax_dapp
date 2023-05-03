import 'package:ax_dapp/service/athlete_models/sport_athlete.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mlb_athlete.g.dart';

@JsonSerializable()
class MLBAthlete extends SportAthlete {
  const MLBAthlete({
    required int id,
    required String name,
    required String team,
    required String position,
    required this.games,
    required this.errors,
    required this.stolenBases,
    required this.plateAppearances,
    required this.weightedOnBasePercentage,
    required this.homeRuns,
    required this.strikeouts,
    required this.saves,
    required this.atBats,
    required double price,
    required String timeStamp,
  }) : super(id, name, team, position, price, timeStamp);

  factory MLBAthlete.fromJson(Map<String, dynamic> json) =>
      _$MLBAthleteFromJson(json);

  @JsonKey(name: 'games')
  final double games;
  @JsonKey(name: 'errors')
  final double errors;
  @JsonKey(name: 'stolenBases')
  final double stolenBases;
  @JsonKey(name: 'plateAppearances')
  final double plateAppearances;
  @JsonKey(name: 'weightedOnBasePercentage')
  final double weightedOnBasePercentage;
  @JsonKey(name: 'HomeRuns')
  final double homeRuns;
  @JsonKey(name: 'Strikeouts')
  final double strikeouts;
  @JsonKey(name: 'Saves')
  final double saves;
  @JsonKey(name: 'AtBats')
  final double atBats;

  Map<String, dynamic> toJson() => _$MLBAthleteToJson(this);
}
