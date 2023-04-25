import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/Probability.dart';
import 'package:ax_dapp/prediction/widgets/prompt_details.dart';
import 'package:flutter/material.dart';
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
          final param_prompt = predictionModel.prompt;
          final param_details = predictionModel.details;
          context.goNamed(
            'prediction',
            params: {'id': param_prompt},
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
                // Probability(prompt: _prompt)
              ],
            ),
            // yes, no
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                YesButton(
                  prompt: predictionModel,
                  isPortraitMode: false,
                  containerWdt: _width,
                ),
                NoButton(
                  prompt: predictionModel,
                  isPortraitMode: false,
                  containerWdt: _width,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
