import 'package:ax_dapp/util/SupportedSports.dart';

class AthleteScoutModel {
  final int id;
  final String name;
  final String position;
  final String team;
  final double warPrice;
  late double bookPrice;
  static const collateralizationMultiplier = 1000;
  final SupportedSport sport;
  final String time;
  final double homeRuns;
  final double strikeOuts;
  final double saves;
  final double stolenBase;
  final double atBats;
  final double weightedOnBasePercentage;
  final double errors;
  final double inningsPlayed;

  final double longTokenPrice;
  final double shortTokenPrice;
  final double longTokenPercentage;
  final double shortTokenPercentage;

  AthleteScoutModel(
      this.id,
      this.name,
      this.position,
      this.team,
      this.warPrice,
      this.sport,
      this.time,
      this.homeRuns,
      this.strikeOuts,
      this.saves,
      this.stolenBase,
      this.atBats,
      this.weightedOnBasePercentage,
      this.errors,
      this.inningsPlayed,
      this.longTokenPrice,
      this.shortTokenPrice,
      this.longTokenPercentage,
      this.shortTokenPercentage
      ) {
    this.bookPrice = this.warPrice * collateralizationMultiplier;
  }
}
