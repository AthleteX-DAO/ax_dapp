import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AthleteScoutModel extends Equatable {
  const AthleteScoutModel({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
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
  });

  final int id;
  final String name;
  final String position;
  final String team;
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
