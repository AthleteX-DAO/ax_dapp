import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/Probability.dart';
import 'package:ax_dapp/predict/widgets/Prompt.dart';
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
