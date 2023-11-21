import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/widgets/24h_volume.dart';
import 'package:ax_dapp/predict/widgets/price.dart';
import 'package:ax_dapp/predict/widgets/widget_factories/prediction_details_widget.dart';
import 'package:ax_dapp/prediction/widgets/prediction_buy_button.dart';
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
              'id': '${predictionModel.id}',
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Prediction Prompt
            PredictionDetailsWidget(predictionModel)
                .predictionDetailsCardsForWeb(_width),

            // Yes Price
            MarketPrice(predictionModel: predictionModel, isYesToken: true),
            // No Price
            MarketPrice(predictionModel: predictionModel, isYesToken: false),

            // price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PredictionBuyButton(
                  predictionModel: predictionModel,
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
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
