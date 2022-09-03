import 'package:json_annotation/json_annotation.dart';

part 'nfl_stats.g.dart';

@JsonSerializable()
class NFLStats {
  const NFLStats({
    required this.passingYards,
    required this.passingTouchdowns,
    required this.reception,
    required this.receivingYards,
    required this.receivingTouchdowns,
    required this.rushingYards,
    required this.offensiveSnapsPlayed,
    required this.defensiveSnapsPlayed,
    required this.price,
    required this.timeStamp,
  });

  factory NFLStats.fromJson(Map<String, dynamic> json) =>
      _$NFLStatsFromJson(json);

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
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'timestamp')
  final String timeStamp;

  Map<String, dynamic> toJson() => _$NFLStatsToJson(this);
}
