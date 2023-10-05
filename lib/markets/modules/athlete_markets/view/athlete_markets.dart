import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/material.dart';

class AthleteMarkets extends StatelessWidget {
  const AthleteMarkets({
    super.key,
    required List<AthleteScoutModel> filteredAthletes,
    required BoxConstraints boxConstraints,
  })  : athletes = filteredAthletes,
        constraints = boxConstraints;

  final List<AthleteScoutModel> athletes;
  final BoxConstraints constraints;

  Widget athleteDesktopMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: athletes.length,
        itemBuilder: (context, index) {
          return DesktopAthleteCard(
            athlete: athletes[index],
            isLongToken: true,
          );
        },
      ),
    );
  }

  Widget athleteMobileMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: athletes.length,
        itemBuilder: (context, index) {
          return MobileAthleteCard(
            athlete: athletes[index],
            marketVsBookPriceIndex: 0,
            isLongToken: true,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: const Center(
        child: SizedBox(
          height: 70,
          child: Text(
            'Check later for Athlete Markets!',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 30,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}
