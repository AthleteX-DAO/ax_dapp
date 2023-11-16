import 'package:ax_dapp/dialogs/predict_short/bloc/short_button_bloc.dart';
import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShortDialog extends StatelessWidget {
  const ShortDialog({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    const paddingHorizontal = 20.0;
    final _width = MediaQuery.of(context).size.width;
    return BlocBuilder<NoButtonBloc, NoButtonState>(
      builder: (context, state) {
        final bloc = context.read<NoButtonBloc>();
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
            ),
            height: 300,
            width: 250,
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
                  width: _width * 0.5,
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
                  width: _width * 0.5,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 30,
                      width: 100,
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
                              shortTokenAddress: predictionModel.noTokenAddress,
                            ),
                          );
                        },
                        child: Text(
                          'Buy',
                          style: textStyle(
                            Colors.black,
                            15,
                            isBold: true,
                            isUline: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}