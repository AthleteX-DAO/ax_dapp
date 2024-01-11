import 'package:ax_dapp/markets/models/models.dart';

import 'package:tokens_repository/tokens_repository.dart';

class AthleteScoutModel extends MarketModel {
  const AthleteScoutModel({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
    required this.athleteTokenAddress,
    required this.longTokenBookPrice,
    required this.longTokenBookPriceUsd,
    required this.longTokenBookPricePercent,
    required this.shortTokenBookPrice,
    required this.shortTokenBookPriceUsd,
    required this.shortTokenBookPricePercent,
    required this.sport,
    required this.time,
    required this.longTokenPrice,
    required this.shortTokenPrice,
    required this.longTokenPercentage,
    required this.shortTokenPercentage,
    required this.longTokenPriceUsd,
    required this.shortTokenPriceUsd,
  }) : super(
          id: id,
          name: name,
          typeOfMarket: SupportedMarkets.athlete,
          marketHash: athleteTokenAddress,
        );

  @override
  final int id;
  @override
  final String name;
  final String position;
  final String team;
  final String athleteTokenAddress;
  final double? longTokenBookPrice;
  final double? longTokenBookPriceUsd;
  final double? shortTokenBookPrice;
  final double? shortTokenBookPriceUsd;
  final double? longTokenBookPricePercent;
  final double? shortTokenBookPricePercent;
  final SupportedSport sport;
  final String time;
  final double? longTokenPrice;
  final double? longTokenPriceUsd;
  final double? shortTokenPrice;
  final double? longTokenPercentage;
  final double? shortTokenPercentage;
  final double? shortTokenPriceUsd;

  static const empty = AthleteScoutModel(
    id: 0,
    name: '',
    position: '',
    team: '',
    athleteTokenAddress: '',
    longTokenBookPrice: 0,
    longTokenBookPriceUsd: 0,
    longTokenBookPricePercent: 0,
    shortTokenBookPrice: 0,
    shortTokenBookPriceUsd: 0,
    shortTokenBookPricePercent: 0,
    sport: SupportedSport.all,
    time: '',
    longTokenPrice: 0,
    shortTokenPrice: 0,
    longTokenPercentage: 0,
    shortTokenPercentage: 0,
    longTokenPriceUsd: 0,
    shortTokenPriceUsd: 0,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        position,
        team,
        longTokenBookPrice,
        longTokenBookPriceUsd,
        longTokenBookPricePercent,
        shortTokenBookPrice,
        shortTokenBookPriceUsd,
        shortTokenBookPricePercent,
        sport,
        time,
        longTokenPrice,
        shortTokenPrice,
        longTokenPercentage,
        shortTokenPercentage,
        longTokenPriceUsd,
        shortTokenPriceUsd,
      ];

  @override
  String toString() =>
      'AthleteScoutModel(id: $id, name: $name, sport: ${sport.name})';
}

extension AthleteScoutModelListX on List<AthleteScoutModel> {
  SupportedSport getAthleteSport(int athleteID) {
    final athleteId = athleteID ~/ 10;
    final athlete = firstWhere(
      (athlete) => athlete.id == athleteId,
      orElse: () => AthleteScoutModel.empty,
    );
    return athlete.sport;
  }

  String getAthleteTeam(int athleteID) {
    final athleteId = athleteID ~/ 10;
    final athlete = firstWhere(
      (athlete) => athlete.id == athleteId,
      orElse: () => AthleteScoutModel.empty,
    );
    return athlete.team;
  }

  AthleteScoutModel findAthlete(int athleteId) {
    final athlete = firstWhere(
      (a) => a.id == athleteId,
      orElse: () => AthleteScoutModel.empty,
    );
    return athlete;
  }
}
