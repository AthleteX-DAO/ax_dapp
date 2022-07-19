import 'package:ax_dapp/util/supported_sports.dart';

class AthleteScoutModel {
  AthleteScoutModel({
    required this.id,
    required this.name,
    required this.position,
    required this.team,
    required this.longTokenBookPrice,
    required this.longTokenBookPriceUsd,
    required this.shortTokenBookPrice,
    required this.shortTokenBookPriceUsd,
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
  final SupportedSport sport;
  final String time;
  final double? longTokenPrice;
  final double? longTokenPriceUsd;
  final double? shortTokenPrice;
  final double? longTokenPercentage;
  final double? shortTokenPercentage;
  final double? shortTokenPriceUsd;
}
