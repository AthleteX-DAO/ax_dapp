import 'package:json_annotation/json_annotation.dart';

part 'nfl_stats.g.dart';

@JsonSerializable()
class NFLStats {
  const NFLStats({
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
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
  @JsonKey(name: 'passingTouchDowns')
  final double passingTouchDowns;
  @JsonKey(name: 'reception')
  final double reception;
  @JsonKey(name: 'receiveYards')
  final double receiveYards;
  @JsonKey(name: 'receiveTouch')
  final double receiveTouch;
  @JsonKey(name: 'rushingYards')
  final double rushingYards;
  @JsonKey(name: 'OffensiveSnapsPlayed')
  final double offensiveSnapsPlayed;
  @JsonKey(name: 'DefensiveSnapsPlayed')
  final double defensiveSnapsPlayed;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'timestamp')
  final String timeStamp;

  Map<String, dynamic> toJson() => _$NFLStatsToJson(this);
}
