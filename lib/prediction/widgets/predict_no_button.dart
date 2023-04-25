import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PredictNoButton extends StatelessWidget {
  const PredictNoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.14,
      height: 36,
      decoration: boxDecoration(
        Colors.grey,
        100,
        0,
        Colors.white,
      ),
      child: TextButton(
        onPressed: () {
          print('no');
        },
        child: TextButton(
          onPressed: () {
            print('no');
          },
          child: const Text('No'),
        ),
      ),
    );
  }
}
