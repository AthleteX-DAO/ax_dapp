import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/24h_volume.dart';
import 'package:ax_dapp/predict/widgets/prediction_prompt.dart';
import 'package:ax_dapp/predict/widgets/view_button.dart';
import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
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
            // Prediction Prompt
            PredictionPrompt(predictionModel: predictionModel),

            // Probability
            MarketProbability(
              prompt: predictionModel.details,
            ),
            // 24H Volume
            Market24HVolume(model: predictionModel),
            // price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                YesButton(
                  prompt: predictionModel,
                ),
                if (_width >= 1090) ...[
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    width: 100,
                    height: 30,
                    decoration:
                        boxDecoration(Colors.transparent, 100, 2, Colors.white),
                    child: ViewButton(
                      predictionModel: predictionModel,
                    ),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
