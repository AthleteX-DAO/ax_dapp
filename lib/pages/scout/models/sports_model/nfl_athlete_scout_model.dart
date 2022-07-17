import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';

class NFLAthleteScoutModel extends AthleteScoutModel {
  NFLAthleteScoutModel({
    required super.id,
    required super.name,
    required super.position,
    required super.team,
    required double? longTokenBookPrice,
    required double? longTokenBookPriceUsd,
    required double? shortTokenBookPrice,
    required double? shortTokenBookPriceUsd,
    required super.sport,
    required super.time,
    required double? longTokenPrice,
    required double? shortTokenPrice,
    required double? longTokenPercentage,
    required double? shortTokenPercentage,
    required double? longTokenPriceUsd,
    required double? shortTokenPriceUsd,
    required this.passingYards,
    required this.passingTouchDowns,
    required this.reception,
    required this.receiveYards,
    required this.receiveTouch,
    required this.rushingYards,
    required this.offensiveSnapsPlayed,
    required this.defensiveSnapsPlayed,
  }) : super(
          longTokenBookPrice: longTokenBookPrice ?? 0.0,
          longTokenBookPriceUsd: longTokenBookPriceUsd ?? 0.0,
          shortTokenBookPrice: shortTokenBookPrice ?? 0.0,
          shortTokenBookPriceUsd: shortTokenBookPriceUsd ?? 0.0,
          longTokenPrice: longTokenPrice ?? 0.0,
          shortTokenPrice: shortTokenPrice ?? 0.0,
          longTokenPercentage: longTokenPercentage ?? 0.0,
          shortTokenPercentage: shortTokenPercentage ?? 0.0,
          longTokenPriceUsd: longTokenPriceUsd ?? 0.0,
          shortTokenPriceUsd: shortTokenPriceUsd ?? 0.0,
        );

  final double passingYards;
  final double passingTouchDowns;
  final double reception;
  final double receiveYards;
  final double receiveTouch;
  final double rushingYards;
  final double offensiveSnapsPlayed;
  final double defensiveSnapsPlayed;
}
