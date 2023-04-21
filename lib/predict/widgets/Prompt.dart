import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PromptDetails extends StatelessWidget {
  const PromptDetails({super.key, required this.model});

  final PredictionModel model;

  Widget promptDetailsCardforWeb() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icon
        SizedBox(
          width: 50,
          child: Icon(
            Icons.question_answer,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.prompt,
                style: textStyle(
                  Colors.white,
                  15,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(model.prompt);
  }
}
