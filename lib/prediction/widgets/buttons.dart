import 'package:ax_dapp/dialogs/predict_long/bloc/long_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_long/long_dialog.dart';
import 'package:ax_dapp/dialogs/predict_mint/bloc/mint_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_redeem/bloc/redeem_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_short/bloc/short_button_bloc.dart';
import 'package:ax_dapp/dialogs/predict_short/short_dialog.dart';
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
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class GenericMintButton extends StatelessWidget {
  const GenericMintButton({
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
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => MintButtonBloc(
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: LongDialog(
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

class ShortButton extends StatelessWidget {
  const ShortButton({
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
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => ShortButtonBloc(
                  repo: context.read<GetBuyInfoUseCase>(),
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: ShortDialog(
                  predictionModel: prompt,
                ),
              ),
            );
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

class GenericRedeemButton extends StatelessWidget {
  const GenericRedeemButton({
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
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => RedeemButtonBloc(
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: LongDialog(
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

class LongButton extends StatelessWidget {
  const LongButton({
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
            showDialog<void>(
              context: context,
              builder: (context) => BlocProvider(
                create: (context) => LongButtonBloc(
                  repo: context.read<GetSwapInfoUseCase>(),
                  eventMarketRepository: context.read<EventMarketRepository>(),
                  streamAppDataChangesUseCase:
                      context.read<StreamAppDataChangesUseCase>(),
                  walletRepository: context.read<WalletRepository>(),
                ),
                child: LongDialog(
                  predictionModel: prompt,
                ),
              ),
            );
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
