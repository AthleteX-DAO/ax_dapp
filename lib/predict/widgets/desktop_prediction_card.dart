import 'package:ax_dapp/dialogs/predict_no/no_button.dart';
import 'package:ax_dapp/dialogs/predict_yes/yes_button.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/prompt_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopPredictionCard extends StatelessWidget {
  const DesktopPredictionCard({
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
    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          context.goNamed(
            'prediction',
            params: {
              'id': predictionModel.id,
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                PromptDetailsCardForWeb(predictionModel: predictionModel),
              ],
            ),
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
