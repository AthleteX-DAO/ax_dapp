import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/Probability.dart';
import 'package:ax_dapp/predict/widgets/Prompt.dart';
import 'package:ax_dapp/predict/widgets/predict_no_button.dart';
import 'package:ax_dapp/predict/widgets/predict_yes_button.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/widgets/widgets.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DesktopPrediction extends StatelessWidget {
  const DesktopPrediction({
    required this.predictionModel,
    required this.minTeamWidth,
    required this.minViewWidth,
    super.key,
  });

  final PredictionModel predictionModel;
  final double minTeamWidth;
  final double minViewWidth;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _prompt = predictionModel.prompt;
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          context.goNamed(
            'prediction',
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          // TODO: Update Buttons to match Figma
          children: <Widget>[
            // prompt, probability
            Row(
              children: <Widget>[
                PromptDetails(
                  model: predictionModel,
                ).promptDetailsCardforWeb(),
                Probability(prompt: _prompt)
              ],
            ),
            // yes, no
            Row(
              children: [
                PredictYesButton(prediction: predictionModel),
                PredictNoButton(prediction: predictionModel)
              ],
            )
          ],
        ),
      ),
    );
  }
}
