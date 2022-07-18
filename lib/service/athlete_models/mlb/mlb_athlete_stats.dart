import 'package:ax_dapp/service/athlete_models/mlb/mlb_stats.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mlb_athlete_stats.g.dart';

@JsonSerializable()
class MLBAthleteStats {
  const MLBAthleteStats({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.statHistory,
  });

  factory MLBAthleteStats.fromJson(Map<String, dynamic> json) =>
      _$MLBAthleteStatsFromJson(json);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'team')
  final String team;
  @JsonKey(name: 'position')
  final String position;
  @JsonKey(name: 'stat_history')
  final List<MLBStats> statHistory;

  Map<String, dynamic> toJson() => _$MLBAthleteStatsToJson(this);
}
