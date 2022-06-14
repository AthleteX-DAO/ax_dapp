import 'package:ax_dapp/service/athleteModels/nfl/NFLStats.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NFLAthleteStats.g.dart';

@JsonSerializable()
class NFLAthleteStats {
  @JsonKey(name: "id")
  final int id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "team")
  final String team;
  @JsonKey(name: "position")
  final String position;
  @JsonKey(name: "stat_history")
  final List<NFLStats> statHistory;

  const NFLAthleteStats(
      {required this.id,
      required this.name,
      required this.team,
      required this.position,
      required this.statHistory});

  factory NFLAthleteStats.fromJson(Map<String, dynamic> json) =>
      _$NFLAthleteStatsFromJson(json);

  Map<String, dynamic> toJson() => _$NFLAthleteStatsToJson(this);
}
