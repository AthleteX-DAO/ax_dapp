import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/away_liquidity.dart';
import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/home_liquidity.dart';

class Liquidity {
  Liquidity({
    required this.homeLiquidity,
    required this.awayLiquidity,
  });

  factory Liquidity.fromJson(Map<String, dynamic> json) {
    return Liquidity(
      homeLiquidity:
          HomeLiquidity.fromJson(json['homeLiquidity'] as Map<String, dynamic>),
      awayLiquidity:
          AwayLiquidity.fromJson(json['awayLiquidity'] as Map<String, dynamic>),
    );
  }
  final HomeLiquidity homeLiquidity;
  final AwayLiquidity awayLiquidity;
}
