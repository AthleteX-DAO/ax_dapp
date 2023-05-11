import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/view/prediction_page.dart';

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
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      // if portrait mode, use 1/3 of container width
      decoration: boxDecoration(primaryOrangeColor, 100, 0, primaryWhiteColor),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) {
                final isWeb = kIsWeb &&
                    (MediaQuery.of(context).orientation ==
                        Orientation.landscape);
                const paddingHorizontal = 40.0;
                const hgt = 450.0;
                const newAmount = 0;
                final wid = isWeb ? 400.0 : 355.0;
                final bloc = BlocProvider.of<PredictionPageBloc>(context);

                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: paddingHorizontal,
                    ),
                    height: hgt,
                    width: wid,
                    decoration:
                        boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                    child: TextButton(
                      onPressed: () {
                        bloc.add(BuyPredictionTokens());
                      },
                      child: Text('Buy',
                          style: textStyle(Colors.black, 20, false, false)),
                    ),
                  ),
                );
              },
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text('Yes', style: textStyle(Colors.black, 20, false, false)),
      ),
    );
  }
}

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
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      // if portrait mode, use 1/3 of container width
      decoration: boxDecoration(Colors.black, 100, 0, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) {
                final isWeb = kIsWeb &&
                    (MediaQuery.of(context).orientation ==
                        Orientation.landscape);
                const paddingHorizontal = 40.0;
                const hgt = 450.0;
                const newAmount = 0;
                final wid = isWeb ? 400.0 : 355.0;

                return Dialog(
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: paddingHorizontal),
                    height: hgt,
                    width: wid,
                    decoration:
                        boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                    child: BlocSelector<PredictionPageBloc, PredictionPageState,
                        String>(
                      selector: (state) {
                        return state.predictionModel.address;
                      },
                      builder: (context, state) {
                        final bloc = context.read<PredictionPageBloc>();
                        return TextButton(
                          onPressed: () {
                            bloc.add(SellPredictionTokens());
                          },
                          child: Text(
                            'Sell',
                            style: textStyle(Colors.black, 20, false, false),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text('No', style: textStyle(Colors.white, 20, false, false)),
      ),
    );
  }
}

class GenericMintButton extends StatelessWidget {
  const GenericMintButton(
      {super.key, required this.isPortraitMode, required this.containerWdt});

  final bool isPortraitMode;
  final double containerWdt;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(primaryOrangeColor, 100, 0, Colors.green),
      child: TextButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              final isWeb = kIsWeb &&
                  (MediaQuery.of(context).orientation == Orientation.landscape);
              const paddingHorizontal = 40.0;
              const hgt = 450.0;
              const newAmount = 0;
              final wid = isWeb ? 400.0 : 355.0;
              return Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  height: hgt,
                  width: wid,
                  decoration:
                      boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                  child: BlocSelector<PredictionPageBloc, PredictionPageState,
                      String>(
                    selector: (state) {
                      return state.predictionModel.address;
                    },
                    builder: (context, isPressed) {
                      final bloc = context.read<PredictionPageBloc>();
                      return TextButton(
                        onPressed: () {
                          bloc.add(MintPredictionTokens());
                        },
                        child: Text(
                          'Mint',
                          style: textStyle(Colors.black, 20, false, false),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Text(
          'Mint',
          style: textStyle(Colors.black, 20, false, false),
        ),
      ),
    );
  }
}

class GenericRedeemButton extends StatelessWidget {
  const GenericRedeemButton(
      {super.key, required this.containerWdt, required this.isPortraitMode});

  final double containerWdt;
  final bool isPortraitMode;

  @override
  Widget build(BuildContext context) {
    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    const paddingHorizontal = 40.0;
    const hgt = 450.0;
    const newAmount = 0;
    final wid = isWeb ? 400.0 : 355.0;
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(Colors.greenAccent, 100, 0, Colors.white10),
      child: TextButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: paddingHorizontal),
                  height: hgt,
                  width: wid,
                  decoration:
                      boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
                  child: BlocSelector<PredictionPageBloc, PredictionPageState,
                      String>(
                    selector: (state) {
                      return state.predictionModel.address;
                    },
                    builder: (context, isPressed) {
                      final bloc = context.read<PredictionPageBloc>();
                      return TextButton(
                        onPressed: () {
                          bloc.add(RedeemPredictionTokens());
                        },
                        child: Text(
                          'Redeem',
                          style: textStyle(Colors.black, 20, false, false),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        child: Text(
          'Redeem',
          style: textStyle(Colors.black, 20, false, false),
        ),
      ),
    );
  }
}
