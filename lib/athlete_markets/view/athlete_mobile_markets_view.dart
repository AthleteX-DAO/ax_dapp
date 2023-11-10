import 'package:ax_dapp/athlete_markets/widgets/widgets.dart';
import 'package:ax_dapp/markets/bloc/markets_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AthleteMobileMarketsView extends StatelessWidget {
  const AthleteMobileMarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final athletes = context.read<MarketsPageBloc>().state.athletes;
    return SizedBox(
      height: _height * 0.8,
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
}
