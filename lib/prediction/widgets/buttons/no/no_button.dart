import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/no/bloc/no_button_bloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NoButton extends StatelessWidget {
  const NoButton({
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
    final invalidAddr = GoRouter.of(context).location.contains('prediction') &&
        prompt.yesTokenAddress.isEmpty;
    var hgt = 300.0;
    if (_height < 305) hgt = _height;

    return BlocProvider(
      create: (context) => NoButtonBloc(
        repo: RepositoryProvider.of<GetBuyInfoUseCase>(
          context,
        ),
        eventMarketRepository: context.read<EventMarketRepository>(),
      ),
      child: BlocConsumer<NoButtonBloc, NoButtonState>(
        builder: (context, state) {
          final bloc = context.read<NoButtonBloc>();

          return Container(
            width: isPortraitMode ? containerWdt / 3 : 175,
            height: 50,
            // if portrait mode, use 1/3 of container width
            decoration: invalidAddr
                ? boxDecoration(
                    secondaryGreyColor,
                    100,
                    0,
                    primaryWhiteColor,
                  )
                : boxDecoration(
                    Colors.black,
                    100,
                    0,
                    Colors.white,
                  ),
            child: TextButton(
              onPressed: () {
                if (invalidAddr) {
                  return;
                }
                // invalidAddr
                //     ? context.showWarningToast(
                //         title: 'No No-Address',
                //         description:
                //             'You cannot vote when there is no address attatched',
                //       )
                //     : bloc.add(
                bloc.add(
                  FetchBuyInfoRequested(
                    shortTokenAddress: prompt.noTokenAddress,
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
                              ///Title
                              SizedBox(
                                width: wid,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Buy Nuggets Prediction',
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
                                            'Buy: ${state.aptBuyInfo.axPerAptPrice} AX',
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
                                              shortTokenAddress:
                                                  prompt.noTokenAddress,
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
                                    //           shortTokenAddress:
                                    //               prompt.noTokenAddress,
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
              child: Text('No',
                  style: invalidAddr
                      ? textStyle(
                          Colors.black,
                          20,
                          false,
                          false,
                        )
                      : textStyle(
                          Colors.white,
                          20,
                          false,
                          false,
                        )),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
