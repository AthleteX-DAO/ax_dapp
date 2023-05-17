import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/yes/bloc/yes_button_bloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YesButton extends StatelessWidget {
  const YesButton({
    super.key,
    required this.prompt,
    required this.isPortraitMode,
    required this.containerWdt,
  });

  final PredictionModel prompt;
  final bool isPortraitMode;
  final double containerWdt;
  @override
  Widget build(BuildContext context) {
    double paddingHorizontal = 20;

    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    var hgt = 300.0;
    if (_height < 305) hgt = _height;

    return BlocProvider(
      create: (context) => YesButtonBloc(
        repo: RepositoryProvider.of<GetSwapInfoUseCase>(
          context,
        ),
        eventMarketRepository: context.read<EventMarketRepository>(),
      ),
      child: BlocConsumer<YesButtonBloc, YesButtonState>(
        builder: (context, state) {
          final bloc = context.read<YesButtonBloc>();
          return Container(
            width: isPortraitMode ? containerWdt / 3 : 175,
            height: 50,
            // if portrait mode, use 1/3 of container width
            decoration:
                boxDecoration(primaryOrangeColor, 100, 0, primaryWhiteColor),
            child: TextButton(
              onPressed: () {
                bloc.add(
                  FetchSwapInfoRequested(
                    longTokenAddress: prompt.yesTokenAddress,
                  ),
                );

                final isWalletConnected =
                    context.read<WalletBloc>().state.isWalletConnected;
                if (isWalletConnected) {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          padding: EdgeInsets.symmetric(
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
                              /// Title
                              SizedBox(
                                width: wid,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Buy YES Prediction',
                                      style: textStyle(
                                        Colors.white,
                                        20,
                                        false,
                                        false,
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

                              /// Divider
                              Divider(
                                thickness: 0.35,
                                color: Colors.grey[400],
                              ),

                              /// Pair Info
                              SizedBox(
                                width: wid,
                                height: 125,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Buy: ${state.swapInfo.receiveAmount} AX',
                                          ),
                                        ),
                                        // Flexible(
                                        //   child: Text(
                                        //     'Sell: ${state.aptSellInfo.axPrice} AX',
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Flexible(
                                          child:
                                              Text('Potential Payout:  100 AX'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),

                              /// Buy / Sell Buttons
                              SizedBox(
                                width: wid,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Buy Button
                                    Container(
                                      height: 30,
                                      width: isPortraitMode
                                          ? containerWdt / 4
                                          : 135,
                                      decoration: boxDecoration(
                                        primaryOrangeColor,
                                        100,
                                        0,
                                        Colors.white,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          bloc.add(
                                            BuyButtonPressed(
                                              eventMarketAddress:
                                                  prompt.address,
                                              longTokenAddress:
                                                  prompt.yesTokenAddress,
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Buy',
                                          style: textStyle(
                                            Colors.white,
                                            15,
                                            true,
                                            false,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Sell Button
                                    // Container(
                                    //   height: 30,
                                    //   width: isPortraitMode
                                    //       ? containerWdt / 4
                                    //       : 135,
                                    //   decoration: boxDecoration(
                                    //     Colors.black,
                                    //     100,
                                    //     0,
                                    //     Colors.white,
                                    //   ),
                                    //   child: TextButton(
                                    //     onPressed: () {
                                    //       bloc.add(
                                    //         SellButtonPressed(
                                    //           eventMarketAddress:
                                    //               prompt.address,
                                    //           longTokenAddress:
                                    //               prompt.yesTokenAddress,
                                    //         ),
                                    //       );
                                    //     },
                                    //     child: Text(
                                    //       'Sell',
                                    //       style: textStyle(
                                    //         Colors.white,
                                    //         15,
                                    //         true,
                                    //         false,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  context.showWalletWarningToast();
                }
              },
              child:
                  Text('Yes', style: textStyle(Colors.black, 20, false, false)),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
