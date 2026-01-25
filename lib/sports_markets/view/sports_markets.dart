import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:flutter/material.dart';

class SportsMarkets extends StatelessWidget {
  const SportsMarkets({super.key, required this.sportsMarkets, required this.boxConstraints});

  final List<SportsMarketsModel> sportsMarkets;
  final BoxConstraints boxConstraints;

  @override
  Widget build(BuildContext context) {
    if (sportsMarkets.isEmpty) {
      return const Center(child: Text('No sports markets'));
    }
    return ListView.builder(
      itemCount: sportsMarkets.length,
      itemBuilder: (context, index) {
        final market = sportsMarkets[index];
        return ListTile(
          title: Text(market.name),
        );
      },
    );
  }
}
