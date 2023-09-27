import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteMarkets extends StatelessWidget {
  const AthleteMarkets({
    super.key,
    required List<AthleteScoutModel> filteredAthletes,
    required BoxConstraints boxConstraints,
  })  : athletes = filteredAthletes,
        constraints = boxConstraints;

  final List<AthleteScoutModel> athletes;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
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
}
