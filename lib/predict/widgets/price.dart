import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class MarketPrice extends StatelessWidget {
  const MarketPrice({
    required this.predictionModel,
    required this.isYesToken,
    super.key,
  });

  final PredictionModel predictionModel;
  final bool isYesToken;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: _width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// Text
          const SizedBox(
            width: 10,
          ),

          ///Text
          Text(
            isYesToken
                ? '\$${predictionModel.longTokenPriceUsd!.toStringAsFixed(
                    4,
                  )}'
                : '\$${predictionModel.shortTokenPriceUsd!.toStringAsFixed(4)}',
            style: textStyle(
              Colors.amberAccent,
              14,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
