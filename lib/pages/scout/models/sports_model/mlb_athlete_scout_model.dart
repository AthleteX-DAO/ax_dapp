import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';

class MLBAthleteScoutModel extends AthleteScoutModel {
  MLBAthleteScoutModel({
    required super.id,
    required super.name,
    required super.position,
    required super.team,
    required double super.longTokenBookPrice,
    required double super.longTokenBookPriceUsd,
    required double super.shortTokenBookPrice,
    required double super.shortTokenBookPriceUsd,
    required super.sport,
    required super.time,
    required double super.longTokenPrice,
    required double super.shortTokenPrice,
    required double super.longTokenPercentage,
    required double super.shortTokenPercentage,
    required double super.longTokenPriceUsd,
    required double super.shortTokenPriceUsd,
    required this.homeRuns,
    required this.strikeOuts,
    required this.saves,
    required this.stolenBases,
    required this.atBats,
    required this.weightedOnBasePercentage,
    required this.errors,
    required this.inningsPlayed,
  });

  final double homeRuns;
  final double strikeOuts;
  final double saves;
  final double stolenBases;
  final double atBats;
  final double weightedOnBasePercentage;
  final double errors;
  final double inningsPlayed;
}
