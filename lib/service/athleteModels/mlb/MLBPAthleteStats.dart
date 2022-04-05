import 'package:ax_dapp/service/athleteModels/mlb/MLBStats.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MLBPAthleteStats.g.dart';

@JsonSerializable()
class MLBAthleteStats {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "team")
  final String team;
  @JsonKey(name: "position")
  final String position;
  @JsonKey(name: "stat_history")
  final List<MLBStats> statHistory;

  const MLBAthleteStats(
      {required this.id,
      required this.name,
      required this.team,
      required this.position,
      required this.statHistory});

  factory MLBAthleteStats.fromJson(Map<String, dynamic> json) =>
      _$MLBAthleteStatsFromJson(json);

  Map<String, dynamic> toJson() => _$MLBAthleteStatsToJson(this);
}
