import 'package:ax_dapp/predict/predict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VotedMarkets extends StatelessWidget {
  const VotedMarkets({
    super.key,
    required BoxConstraints boxConstraints,
  }) : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final votedMarkets =
        context.read<PredictPageBloc>().state.filteredPredictions;
    Widget votedMarketsList = const SizedBox(
      height: 70,
      child: Text(
        'Check later for Voted Markets!',
        style: TextStyle(
          color: Colors.yellow,
          fontSize: 30,
          fontFamily: 'OpenSans',
        ),
      ),
    );

    if (votedMarkets.isNotEmpty) {
      votedMarketsList = SizedBox(
        height: constraints.maxHeight * 0.8 - 120,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: votedMarkets.length,
          itemBuilder: (context, index) {
            return DesktopPredictionCard(
              predictionModel: votedMarkets[index],
            );
          },
        ),
      );
    }

    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: Center(
        child: votedMarketsList,
      ),
    );
  }
}
