import 'package:auto_size_text/auto_size_text.dart';
import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/prediction_buy_dialog.dart';
import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/sell/prediction_sell_dialog.dart';

import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
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

class BuyEventButton extends StatelessWidget {
  const BuyEventButton({
    super.key,
    required this.predictionModel,
    required this.isPortraitMode,
    required this.containerWdt,
  });

  final PredictionModel predictionModel;
  final bool isPortraitMode;
  final double containerWdt;
  // final bool isLongApt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(primaryOrangeColor, 100, 0, primaryWhiteColor),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                create: (context) => BuyDialogBloc(
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  wallet: GetTotalTokenBalanceUseCase(
                    walletRepository: context.read<WalletRepository>(),
                    tokensRepository: context.read<TokensRepository>(),
                  ),
                  tokensRepository: context.read<TokensRepository>(),
                  repo: RepositoryProvider.of<GetBuyInfoUseCase>(
                    context,
                  ),
                  swapRepository: context.read<SwapRepository>(),
                  // TODO: Setup some catch for the AthleteID
                  athleteId: 0,
                  predictionId: predictionModel.id,
                ),
                child: BuyPredictionDialog(
                  predictionModel: predictionModel,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Buy',
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

class SellEventButton extends StatelessWidget {
  const SellEventButton({
    super.key,
    required this.predictionModel,
    required this.isPortraitMode,
    required this.containerWdt,
  });

  final PredictionModel predictionModel;
  final bool isPortraitMode;
  final double containerWdt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(Colors.white, 100, 0, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;

          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) => SellDialogBloc(
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  tokensRepository: context.read<TokensRepository>(),
                  repo: RepositoryProvider.of<GetSellInfoUseCase>(context),
                  wallet: GetTotalTokenBalanceUseCase(
                    walletRepository: context.read<WalletRepository>(),
                    tokensRepository: context.read<TokensRepository>(),
                  ),
                  swapRepository: context.read<SwapRepository>(),
                  athleteId: 0,
                ),
                child: SellPredictionDialog(
                  predictionModel: predictionModel,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Sell',
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
