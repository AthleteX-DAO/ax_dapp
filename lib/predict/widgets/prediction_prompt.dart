import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PredictionPrompt extends StatelessWidget {
  const PredictionPrompt({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 50,
              child: Icon(
                Icons.question_answer,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(
              width: _width < 768 ? 100 : 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    predictionModel.prompt,
                    style: textStyle(
                      Colors.white,
                      15,
                      isBold: false,
                      isUline: false,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Event Prediction',
                    style: textStyle(
                      Colors.grey,
                      13,
                      isBold: false,
                      isUline: false,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
