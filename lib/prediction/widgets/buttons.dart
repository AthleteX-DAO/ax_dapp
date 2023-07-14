import 'package:ax_dapp/dialogs/predict_mint/bloc/mint_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_no/bloc/no_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_no/no_dialog.dart';
import 'package:ax_dapp/dialogs/predict_redeem/bloc/redeem_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_yes/bloc/yes_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_yes/yes_dialog.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class GenericMintButton extends StatelessWidget {
  const GenericMintButton({
    super.key,
    required this.isPortraitMode,
    required this.prompt,
    required this.containerWdt,
  });

  final bool isPortraitMode;
  final PredictionModel prompt;
  final double containerWdt;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(primaryOrangeColor, 100, 0, Colors.green),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => MintButtonBloc(
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: YesDialog(
                  predictionModel: prompt,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Mint',
          style: textStyle(Colors.black, 20, false, false),
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
    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width < 768 ? 100 : 200,
      height: 50,
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
            context.showWarningToast(
              title: 'Invalid Address',
              description: 'Addresses not valid!',
            );
          }
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => NoButtonBloc(
                  repo: context.read<GetBuyInfoUseCase>(),
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: NoDialog(
                  predictionModel: prompt,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'No',
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
                ),
        ),
      ),
    );
  }
}

class GenericRedeemButton extends StatelessWidget {
  const GenericRedeemButton({
    super.key,
    required this.containerWdt,
    required this.isPortraitMode,
    required this.prompt,
  });

  final double containerWdt;
  final PredictionModel prompt;
  final bool isPortraitMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(Colors.black, 100, 0, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => RedeemButtonBloc(
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: YesDialog(
                  predictionModel: prompt,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Redeem',
          style: textStyle(Colors.white, 20, false, false),
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
    final _width = MediaQuery.of(context).size.width;
    return Container(
      width: _width < 768 ? 100 : 200,
      height: 50,
      decoration: invalidAddr
          ? boxDecoration(
              secondaryGreyColor,
              100,
              0,
              primaryWhiteColor,
            )
          : boxDecoration(
              primaryOrangeColor,
              100,
              0,
              primaryWhiteColor,
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
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => YesButtonBloc(
                  repo: context.read<GetSwapInfoUseCase>(),
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: YesDialog(
                  predictionModel: prompt,
                ),
              ),
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
