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
    required double price,
    required String timeStamp,
  }) : super(id, name, team, position, price, timeStamp);

  // ignore: prefer_constructors_over_static_methods
  static MLBAthlete fromJson(Map<String, dynamic> json) {
    return MLBAthlete(
      id: json['ID'] as int,
      name: json['Name'] as String,
      team: json['Team'] as String,
      position: json['Position'] as String,
      games: json['Games'] as double,
      errors: json['Errors'] as double,
      stolenBases: json['StolenBases'] as double,
      plateAppearances: json['PlateAppearances'] as double,
      weightedOnBasePercentage: json['WeightedOnBasePercentage'] as double,
      price: (json['BookPrice'] as num).toDouble(),
      timeStamp: json['Time'] as String,
    );
  }

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

  // Map<String, dynamic> toJson() => _$MLBAthleteToJson(this);
}
