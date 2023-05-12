import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/prediction/widgets/buttons/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class AdvancedFeatures extends StatefulWidget {
  AdvancedFeatures({
    super.key,
    required this.model,
  });

  PredictionModel model;

  @override
  State<AdvancedFeatures> createState() => _AdvancedFeaturesState();
}

class _AdvancedFeaturesState extends State<AdvancedFeatures> {
  _AdvancedFeaturesState();

  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Advanced Features',
                style: textStyle(
                  primaryOrangeColor,
                  20,
                  isBold: true,
                  isUline: false,
                ),
              ),
              Switch(
                value: switchValue,
                onChanged: (val) {
                  setState(() {
                    switchValue = val;
                  });
                },
              ),
            ],
          ),
          if (switchValue)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Divider(
                  thickness: 1,
                  color: greyTextColor,
                ),
                GenericMintButton(
                  containerWdt: 100,
                  isPortraitMode: false,
                  prompt: widget.model,
                ),
                GenericRedeemButton(
                  containerWdt: 100,
                  isPortraitMode: false,
                  prompt: widget.model,
                ),
              ],
            )
          else
            Container(),
        ],
      ),
    );
  }
}
