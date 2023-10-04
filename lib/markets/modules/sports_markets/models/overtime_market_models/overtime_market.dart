import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/liquidity.dart';
import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/odds.dart';
import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/price_impact.dart';

class OvertimeMarket {
  OvertimeMarket({
    required this.address,
    required this.gameId,
    required this.sport,
    required this.leagueId,
    required this.leagueName,
    required this.type,
    required this.maturityDate,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.isResolved,
    required this.isOpen,
    required this.isCanceled,
    required this.isPaused,
    required this.isOneSideMarket,
    required this.spread,
    required this.total,
    required this.odds,
    required this.priceImpact,
    required this.liquidity,
  });

  factory OvertimeMarket.fromJson(Map<String, dynamic> json) {
    return OvertimeMarket(
      address: json['address'] as String,
      gameId: json['gameId'] as String,
      sport: json['sport'] as String,
      leagueId: json['leagueId'] as int,
      leagueName: json['leagueName'] as String,
      type: json['type'] as String,
      maturityDate: json['maturityDate'] as String,
      homeTeam: json['homeTeam'] as String,
      awayTeam: json['awayTeam'] as String,
      homeScore: json['homeScore'] as int,
      awayScore: json['awayScore'] as int,
      isResolved: json['isResolved'] as bool,
      isOpen: json['isOpen'] as bool,
      isCanceled: json['isCanceled'] as bool,
      isPaused: json['isPaused'] as bool,
      isOneSideMarket: json['isOneSideMarket'] as bool,
      spread: json['spread'] as int,
      total: json['total'] as int,
      odds: Odds.fromJson(json['odds'] as Map<String, dynamic>),
      priceImpact:
          PriceImpact.fromJson(json['priceImpact'] as Map<String, dynamic>),
      liquidity: Liquidity.fromJson(json['liquidity'] as Map<String, dynamic>),
    );
  }

  final String address;
  final String gameId;
  final String sport;
  final int leagueId;
  final String leagueName;
  final String type;
  final String maturityDate;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final bool isResolved;
  final bool isOpen;
  final bool isCanceled;
  final bool isPaused;
  final bool isOneSideMarket;
  final int spread;
  final int total;
  final Odds odds;
  final PriceImpact priceImpact;
  final Liquidity liquidity;
}
