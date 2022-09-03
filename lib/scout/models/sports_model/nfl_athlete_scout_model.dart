import 'package:ax_dapp/scout/models/athlete_scout_model.dart';

class NFLAthleteScoutModel extends AthleteScoutModel {
  const NFLAthleteScoutModel({
    required super.id,
    required super.name,
    required super.position,
    required super.team,
    required double? longTokenBookPrice,
    required double? longTokenBookPriceUsd,
    required double? longTokenBookPricePercent,
    required double? shortTokenBookPrice,
    required double? shortTokenBookPriceUsd,
    required double? shortTokenBookPricePercent,
    required super.sport,
    required super.time,
    required double? longTokenPrice,
    required double? shortTokenPrice,
    required double? longTokenPercentage,
    required double? shortTokenPercentage,
    required double? longTokenPriceUsd,
    required double? shortTokenPriceUsd,
    required this.passingYards,
    required this.passingTouchdowns,
    required this.reception,
    required this.receivingYards,
    required this.receivingTouchdowns,
    required this.rushingYards,
    required this.offensiveSnapsPlayed,
    required this.defensiveSnapsPlayed,
  }) : super(
          longTokenBookPrice: longTokenBookPrice ?? 0.0,
          longTokenBookPriceUsd: longTokenBookPriceUsd ?? 0.0,
          longTokenBookPricePercent: longTokenBookPricePercent ?? 0.0,
          shortTokenBookPrice: shortTokenBookPrice ?? 0.0,
          shortTokenBookPriceUsd: shortTokenBookPriceUsd ?? 0.0,
          shortTokenBookPricePercent: shortTokenBookPricePercent ?? 0.0,
          longTokenPrice: longTokenPrice ?? 0.0,
          shortTokenPrice: shortTokenPrice ?? 0.0,
          longTokenPercentage: longTokenPercentage ?? 0.0,
          shortTokenPercentage: shortTokenPercentage ?? 0.0,
          longTokenPriceUsd: longTokenPriceUsd ?? 0.0,
          shortTokenPriceUsd: shortTokenPriceUsd ?? 0.0,
        );

  final double passingYards;
  final double passingTouchdowns;
  final double reception;
  final double receivingYards;
  final double receivingTouchdowns;
  final double rushingYards;
  final double offensiveSnapsPlayed;
  final double defensiveSnapsPlayed;

  @override
  List<Object?> get props => super.props
    ..addAll([
      passingYards,
      passingTouchdowns,
      reception,
      receivingYards,
      receivingTouchdowns,
      rushingYards,
      offensiveSnapsPlayed,
      defensiveSnapsPlayed,
    ]);
}
