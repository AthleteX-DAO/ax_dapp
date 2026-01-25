import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AthleteScoutModel extends Equatable {
  const AthleteScoutModel({
    required this.id,
    required this.name,
    required this.sport,
    this.team = '',
    this.longTokenBookPrice = 0,
    this.shortTokenBookPrice = 0,
    this.longTokenBookPricePercent = 0,
    this.shortTokenBookPricePercent = 0,
  });

  final int id;
  final String name;
  final SupportedSport sport;
  final String team;
  final double? longTokenBookPrice;
  final double? shortTokenBookPrice;
  final double? longTokenBookPricePercent;
  final double? shortTokenBookPricePercent;

  static const empty = AthleteScoutModel(
    id: 0,
    name: '',
    sport: SupportedSport.MLB,
  );

  @override
  List<Object?> get props => [
        id,
        name,
        sport,
        team,
        longTokenBookPrice,
        shortTokenBookPrice,
        longTokenBookPricePercent,
        shortTokenBookPricePercent,
      ];
}

extension AthleteListExtensions on List<AthleteScoutModel> {
  SupportedSport getAthleteSport(int id) {
    return firstWhere(
      (athlete) => athlete.id == id,
      orElse: () => AthleteScoutModel.empty,
    ).sport;
  }

  String getAthleteTeam(int id) {
    return firstWhere(
      (athlete) => athlete.id == id,
      orElse: () => AthleteScoutModel.empty,
    ).team;
  }

  AthleteScoutModel findAthlete(int athleteId) {
    return firstWhere(
      (athlete) => athlete.id == athleteId,
      orElse: () => AthleteScoutModel.empty,
    );
  }
}
