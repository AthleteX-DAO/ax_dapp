import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/util/SupportedSports.dart';

class MLBAthleteScoutModel extends AthleteScoutModel {
  final double homeRuns;
  final double strikeOuts;
  final double saves;
  final double stolenBases;
  final double atBats;
  final double weightedOnBasePercentage;
  final double errors;
  final double inningsPlayed;
  MLBAthleteScoutModel({
    required int id,
    required String name,
    required String position,
    required String team,
    required double longTokenBookPrice,
    required double longTokenBookPriceUsd,
    required double shortTokenBookPrice,
    required double shortTokenBookPriceUsd,
    required SupportedSport sport,
    required String time,
    required double longTokenPrice,
    required double shortTokenPrice,
    required double longTokenPercentage,
    required double shortTokenPercentage,
    required double longTokenPriceUsd,
    required double shortTokenPriceUsd,
    required this.homeRuns,
    required this.strikeOuts,
    required this.saves,
    required this.stolenBases,
    required this.atBats,
    required this.weightedOnBasePercentage,
    required this.errors,
    required this.inningsPlayed,
  }) : super(
            id: id,
            name: name,
            position: position,
            team: team,
            longTokenBookPrice: longTokenBookPrice,
            longTokenBookPriceUsd: longTokenBookPriceUsd,
            shortTokenBookPrice: shortTokenBookPrice,
            shortTokenBookPriceUsd: shortTokenBookPriceUsd,
            sport: sport,
            time: time,
            longTokenPrice: longTokenPrice,
            shortTokenPrice: shortTokenPrice,
            longTokenPercentage: longTokenPercentage,
            shortTokenPercentage: shortTokenPercentage,
            longTokenPriceUsd: longTokenPriceUsd,
            shortTokenPriceUsd: shortTokenPriceUsd);
}
