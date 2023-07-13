import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/widgets/prediction_prompt.dart';
import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopPredictionCard extends StatelessWidget {
  const DesktopPredictionCard({
    required this.predictionModel,
    super.key,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
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
            PredictionPrompt(predictionModel: predictionModel),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                YesButton(
                  prompt: predictionModel,
                ),
                NoButton(
                  prompt: predictionModel,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
