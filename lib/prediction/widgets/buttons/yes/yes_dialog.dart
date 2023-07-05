import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/yes/bloc/yes_button_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YesDialog extends StatelessWidget {
  const YesDialog({
    super.key,
    required this.hgt,
    required this.wid,
    required this.predictionModel,
    required this.isPortraitMode,
    required this.containerWdt,
  });

  final double hgt;
  final double wid;
  final PredictionModel predictionModel;
  final bool isPortraitMode;
  final double containerWdt;

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = 20.0;
    return BlocBuilder<YesButtonBloc, YesButtonState>(
      builder: (context, state) {
        final bloc = context.read<YesButtonBloc>();
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
            ),
            height: hgt,
            width: wid,
            decoration: boxDecoration(
              Colors.grey[900]!,
              30,
              0,
              Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Buy ${predictionModel.yesName}',
                        style: textStyle(
                          Colors.white,
                          20,
                          isBold: false,
                          isUline: false,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 0.35,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  width: wid,
                  height: 125,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              'Buy: ${state.swapInfo.receiveAmount} AX',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Flexible(
                            child: Text('Potential Payout:  100 AX'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: wid,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 30,
                        width: isPortraitMode ? containerWdt / 4 : 135,
                        decoration: boxDecoration(
                          Colors.amber[400]!,
                          100,
                          0,
                          Colors.white,
                        ),
                        child: TextButton(
                          onPressed: () {
                            bloc.add(
                              BuyButtonPressed(
                                eventMarketAddress: predictionModel.address,
                                longTokenAddress:
                                    predictionModel.yesTokenAddress,
                              ),
                            );
                          },
                          child: Text(
                            'Buy',
                            style: textStyle(
                              Colors.white,
                              15,
                              isBold: true,
                              isUline: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
