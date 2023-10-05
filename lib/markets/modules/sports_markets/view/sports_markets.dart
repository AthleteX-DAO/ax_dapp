import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/material.dart';

class SportsMarkets extends StatelessWidget {
  const SportsMarkets({
    super.key,
    required List<SportsMarketsModel> sportsMarkets,
    required BoxConstraints boxConstraints,
  })  : liveSportsMarkets = sportsMarkets,
        constraints = boxConstraints;

  final List<SportsMarketsModel> liveSportsMarkets;
  final BoxConstraints constraints;

  Widget sportsDesktopMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: liveSportsMarkets.length,
        itemBuilder: (context, index) {
          return DesktopSportsCard(
            sportsMarketsModel: liveSportsMarkets[index],
          );
        },
      ),
    );
  }

  Widget sportsMobileMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (content, index) {
          return MobileSportsCard(
            sportsMarketsModel: liveSportsMarkets[index],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: liveSportsMarkets.length,
        itemBuilder: (context, index) {
          return DesktopSportsCard(
            sportsMarketsModel: liveSportsMarkets[index],
          );
        },
      ),
    );
  }
}
