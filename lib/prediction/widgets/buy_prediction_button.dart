import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PredictionBuyButton extends StatelessWidget {
  const PredictionBuyButton({
    super.key,
    required this.model,
  });

  final PredictionModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      height: 36,
      decoration: boxDecoration(
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
        100,
        0,
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
      ),
      child: TextButton(
        onPressed: () {},
        child: const BuyText(),
      ),
    );
  }
}
