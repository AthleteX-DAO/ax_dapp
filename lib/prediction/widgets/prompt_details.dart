import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';

class PromptDetails extends StatelessWidget {
  const PromptDetails({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var wid = _width * 0.4;
    if (_width < 1160) wid = _width * 0.95;

    return Container(
      width: wid,
      height: 500,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price Overview',
                      style: textStyle(
                        Colors.white,
                        24,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    const Spacer(),
                    // SizedBox(
                    //   width: 100,
                    //   height: 20,
                    //   child: Text(
                    //     'Probability',
                    //     style: textStyle(
                    //       Colors.grey,
                    //       14,
                    //       isBold: false,
                    //       isUline: false,
                    //     ),
                    //   ),
                    // ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Max',
                        style: textStyle(
                          greyTextColor,
                          14,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: greyTextColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${predictionModel.yesName} Price',
                      style: textStyle(
                        greyTextColor,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    // const SizedBox(
                    //   width: 100,
                    //   child: Text('Odds Unknown'),
                    // ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: const SizedBox(
                        child: Text('100.0 AX'),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${predictionModel.noName} Price',
                      style: textStyle(
                        greyTextColor,
                        20,
                        isBold: false,
                        isUline: false,
                      ),
                    ),
                    // const SizedBox(
                    //   width: 100,
                    //   child: Text('Odds Unknown'),
                    // ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: const SizedBox(
                        child: Text('000.0 AX'),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // Long & Short Button

          SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  thickness: 1,
                  color: greyTextColor,
                ),
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

          // Advanced Features
          // SizedBox(
          //   height: 180,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       AdvancedFeatures(
          //         model: model,
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
