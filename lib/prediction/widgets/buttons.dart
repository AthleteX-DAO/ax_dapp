import 'package:auto_size_text/auto_size_text.dart';
import 'package:ax_dapp/dialogs/dialogs.dart';

import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class MintPredictionButton extends StatelessWidget {
  const MintPredictionButton({
    super.key,
    required this.prompt,
  });

  final PredictionModel prompt;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width < 768 ? 100 : 200,
      height: 50,
      decoration: boxDecoration(primaryOrangeColor, 100, 0, Colors.green),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            // showDialog<void>(
            //   context: context,
            //   builder: (context) => BlocProvider(
            //     create: (context) => MintDialogBloc(
            //       eventMarketRepository: context.read<EventMarketRepository>(),
            //       streamAppDataChangesUseCase:
            //           context.read<StreamAppDataChangesUseCase>(),
            //       walletRepository: context.read<WalletRepository>(),
            //     ),
            //     child: MintPredictionDialog(
            //       predictionModel: prompt,
            //     ),
            //   ),
            // );
            context.showWalletWarningToast();
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Mint',
          style: textStyle(
            Colors.black,
            20,
            isBold: false,
            isUline: false,
          ),
        ),
      ),
    );
  }
}

class NoButton extends StatelessWidget {
  const NoButton({
    super.key,
    required this.prompt,
  });

  final PredictionModel prompt;
  @override
  Widget build(BuildContext context) {
    final invalidAddr = GoRouter.of(context).location.contains('prediction') &&
        prompt.yesTokenAddress.isEmpty;
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      height: 36,
      decoration: invalidAddr
          ? boxDecoration(
              secondaryGreyColor,
              100,
              0,
              primaryWhiteColor,
            )
          : boxDecoration(
              primaryGreenColor,
              100,
              0,
              Colors.white,
            ),
      child: TextButton(
        onPressed: () {
          if (invalidAddr) {
            context.showWarningToast(
              title: 'Invalid Address',
              description: 'Addresses not valid!',
            );
          }
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            // showDialog<void>(
            //   context: context,
            //   builder: (context) => BlocProvider(
            //     create: (context) => NoButtonBloc(
            //       repo: context.read<GetBuyInfoUseCase>(),
            //       eventMarketRepository: context.read<EventMarketRepository>(),
            //       streamAppDataChangesUseCase:
            //           context.read<StreamAppDataChangesUseCase>(),
            //       walletRepository: context.read<WalletRepository>(),
            //     ),
            //     child: ShortDialog(
            //       predictionModel: prompt,
            //     ),
            //   ),
            // );
            context.showWalletWarningToast();
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Short',
          style: invalidAddr
              ? textStyle(
                  Colors.black,
                  20,
                  isBold: false,
                  isUline: false,
                )
              : textStyle(
                  Colors.white,
                  20,
                  isBold: false,
                  isUline: false,
                ),
        ),
      ),
    );
  }
}

class RedeemPredictionButton extends StatelessWidget {
  const RedeemPredictionButton({
    super.key,
    required this.prompt,
  });

  final PredictionModel prompt;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width < 768 ? 100 : 200,
      height: 50,
      decoration: boxDecoration(Colors.black, 100, 0, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            // showDialog<void>(
            //   context: context,
            //   builder: (context) => BlocProvider(
            //     create: (context) => RedeemDialogBloc(
            //       eventMarketRepository: context.read<EventMarketRepository>(),
            //       streamAppDataChangesUseCase:
            //           context.read<StreamAppDataChangesUseCase>(),
            //       walletRepository: context.read<WalletRepository>(),
            //     ),
            //     child: RedeemPredictionsDialog(
            //       predictionModel: prompt,
            //     ),
            //   ),
            // );
            context.showWalletWarningToast();
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Redeem',
          style: textStyle(
            Colors.white,
            20,
            isBold: false,
            isUline: false,
          ),
        ),
      ),
    );
  }
}

class YesButton extends StatelessWidget {
  const YesButton({
    super.key,
    required this.prompt,
  });

  final PredictionModel prompt;
  @override
  Widget build(BuildContext context) {
    final invalidAddr = GoRouter.of(context).location.contains('prediction') &&
        prompt.yesTokenAddress.isEmpty;
    return Container(
      width: MediaQuery.of(context).size.width * 0.20,
      height: 36,
      decoration: boxDecoration(
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
        100,
        0,
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
      ),
      child: TextButton(
        onPressed: () {
          if (invalidAddr) {
            context.showWarningToast(
              title: 'Invalid Address',
              description: 'Addresses not valid!',
            );
          }
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            // showDialog<void>(
            //   context: context,
            //   builder: (context) => BlocProvider(
            //     create: (context) => YesButtonBloc(
            //       repo: context.read<GetSwapInfoUseCase>(),
            //       eventMarketRepository: context.read<EventMarketRepository>(),
            //       streamAppDataChangesUseCase:
            //           context.read<StreamAppDataChangesUseCase>(),
            //       walletRepository: context.read<WalletRepository>(),
            //     ),
            //     child: LongDialog(
            //       predictionModel: prompt,
            //     ),
            //   ),
            // );
            context.showWalletWarningToast();
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Long',
          style: textStyle(
            Colors.black,
            20,
            isBold: false,
            isUline: false,
          ),
        ),
      ),
    );
  }
}

class ProposeButton extends StatelessWidget {
  const ProposeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 25,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
      child: TextButton(
        onPressed: () {
          const urlString = 'https://oracle.uma.xyz/';
          launchUrl(Uri.parse(urlString));
        },
        child: AutoSizeText(
          'Propose Resolution',
          style: textStyle(
            Colors.white,
            20,
            isBold: true,
            isUline: false,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
