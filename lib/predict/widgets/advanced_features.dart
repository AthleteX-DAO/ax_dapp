import 'package:ax_dapp/athlete/athlete.dart';
import 'package:ax_dapp/prediction/widgets/buttons/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdvancedFeatures extends StatefulWidget {
  const AdvancedFeatures({
    super.key,
  });

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
                const GenericMintButton(
                  containerWdt: 100,
                  isPortraitMode: false,
                ),
                const GenericRedeemButton(
                  containerWdt: 100,
                  isPortraitMode: false,
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
