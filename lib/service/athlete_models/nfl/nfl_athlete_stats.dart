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

  static NFLAthleteStats fromJson(Map<String, dynamic> json) {
    final statsItems = <double>[
      (json['PassingYards'] as num).toDouble(),
      (json['PassingTouchdowns'] as num).toDouble(),
      (json['Reception'] as num).toDouble(),
      (json['ReceivingYards'] as num).toDouble(),
      (json['ReceivingTouchdowns'] as num).toDouble(),
      (json['RushingYards'] as num).toDouble(),
      0,
      0,
      (json['BookPrice'] as num).toDouble(),
    ];
    final stats = <NFLStats>[
      NFLStats.create(statsItems, json['Time'] as String)
    ];

    return NFLAthleteStats(
      id: json['ID'] as int,
      name: json['Name'] as String,
      team: json['Team'] as String,
      position: json['Position'] as String,
      statHistory: stats,
    );
  }

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
