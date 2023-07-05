import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/prediction/widgets/buttons/no/bloc/no_button_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoDialog extends StatelessWidget {
  const NoDialog({
    super.key,
    required this.hgt,
    required this.wid,
    required this.isPortraitMode,
    required this.containerWdt,
    required this.predictionModel,
  });

  final double hgt;
  final double wid;
  final bool isPortraitMode;
  final double containerWdt;
  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = 20.0;

    return BlocBuilder<NoButtonBloc, NoButtonState>(
      builder: (context, state) {
        final bloc = context.read<NoButtonBloc>();
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
                        'Buy ${predictionModel.noName}',
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
                              'Buy: ${state.aptBuyInfo.axPerAptPrice} AX',
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
                                shortTokenAddress:
                                    predictionModel.noTokenAddress,
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
