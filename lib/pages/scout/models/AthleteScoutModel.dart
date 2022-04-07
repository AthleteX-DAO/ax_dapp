import 'package:ax_dapp/util/SupportedSports.dart';

class AthleteScoutModel {
  final int id;
  final String name;
  final String position;
  final String team;
  final double marketPrice;
  final SupportedSport sport;

  AthleteScoutModel(this.id, this.name, this.position, this.team, this.marketPrice, this.sport);
}

