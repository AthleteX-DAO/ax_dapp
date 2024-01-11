import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewButton extends StatelessWidget {
  const ViewButton({
    required this.predictionModel,
    super.key,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.goNamed(
          'prediction',
          params: {
            'id': predictionModel.id.toString() + predictionModel.prompt,
          },
        );
      },
      child: SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'View',
              style: textStyle(
                Colors.white,
                16,
                isBold: false,
                isUline: false,
              ),
            ),
            const Icon(
              Icons.arrow_right,
              size: 25,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
