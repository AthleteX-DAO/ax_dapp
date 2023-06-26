import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/widgets/buttons/buttons.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvancedFeatures extends StatelessWidget {
  const AdvancedFeatures({
    super.key,
    required this.model,
  });

  final PredictionModel model;

  @override
  Widget build(BuildContext context) {
    final isToggled =
        context.select((PredictionPageBloc bloc) => bloc.state.isToggled);
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
                value: isToggled,
                onChanged: (val) {
                  context
                      .read<PredictionPageBloc>()
                      .add(ToggleAdvanceFeatures());
                },
              ),
            ],
          ),
          if (isToggled)
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
                  prompt: model,
                ),
                GenericRedeemButton(
                  containerWdt: 100,
                  isPortraitMode: false,
                  prompt: model,
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
