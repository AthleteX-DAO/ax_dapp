import 'package:ax_dapp/sports_markets/models/overtime_market_models/away_odds.dart';
import 'package:ax_dapp/sports_markets/models/overtime_market_models/home_odds.dart';

class Odds {
  Odds({
    this.homeOdds = HomeOdds.empty,
    this.awayOdds = AwayOdds.empty,
  });

  factory Odds.fromJson(Map<String, dynamic> json) {
    return Odds(
      homeOdds: HomeOdds.fromJson(json['homeOdds'] as Map<String, dynamic>),
      awayOdds: AwayOdds.fromJson(json['awayOdds'] as Map<String, dynamic>),
    );
  }

  final HomeOdds? homeOdds;
  final AwayOdds? awayOdds;
}
