import 'package:ax_dapp/service/athlete_models/nfl/nfl_stats.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nfl_athlete_stats.g.dart';

@JsonSerializable()
class NFLAthleteStats {
  const NFLAthleteStats({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.statHistory,
  });

  factory NFLAthleteStats.fromJson(Map<String, dynamic> json) =>
      _$NFLAthleteStatsFromJson(json);

  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'team')
  final String team;
  @JsonKey(name: 'position')
  final String position;
  @JsonKey(name: 'stat_history')
  final List<NFLStats> statHistory;

  Map<String, dynamic> toJson() => _$NFLAthleteStatsToJson(this);
}
