import 'package:ax_dapp/my_liquidity/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportToken extends StatelessWidget {
  const SportToken({
    super.key,
    required this.sport,
    required this.symbol,
  });

  final SupportedSport sport;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    if (sport == SupportedSport.all) return SimpleToken(symbol: symbol);
    return BadgeToken(sport: sport, symbol: symbol);
  }
}
