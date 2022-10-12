import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/dialogs/mint/bloc/mint_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/mint/mint_dialog.dart';
import 'package:ax_dapp/dialogs/redeem/bloc/redeem_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/redeem/redeem_dialog.dart';
import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/sell/sell_dialog.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({
    super.key,
    required this.athlete,
    required this.isPortraitMode,
    required this.containerWdt,
    required this.isLongApt,
    required this.goToTradePage,
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;
  final bool isLongApt;
  final void Function() goToTradePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      //if app is in portrait, buyButton will use 1/4 of the total width
      decoration: boxDecoration(primaryOrangeColor, 100, 0, primaryWhiteColor),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) => BuyDialogBloc(
                  walletRepository: context.read<WalletRepository>(),
                  streamAppDataChanges:
                      context.read<StreamAppDataChangesUseCase>(),
                  tokensRepository: context.read<TokensRepository>(),
                  repo: RepositoryProvider.of<GetBuyInfoUseCase>(context),
                  wallet: GetTotalTokenBalanceUseCase(
                    walletRepository: context.read<WalletRepository>(),
                    tokensRepository: context.read<TokensRepository>(),
                  ),
                  swapController: Get.find(),
                  athleteId: athlete.id,
                ),
                child: BuyDialog(
                  athlete: athlete,
                  athleteName: athlete.name,
                  aptPrice: athlete.longTokenBookPrice!,
                  athleteId: athlete.id,
                  isLongApt: isLongApt,
                  goToTradePage: goToTradePage,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text('Buy', style: textStyle(Colors.black, 20, false, false)),
      ),
    );
  }
}

class SellButton extends StatelessWidget {
  const SellButton({
    super.key,
    required this.athlete,
    required this.isPortraitMode,
    required this.containerWdt,
    required this.isLongApt,
    required this.goToTradePage,
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;
  final bool isLongApt;
  final void Function() goToTradePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      // if portrait mode, use 1/3 of container width
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
                  swapController: Get.find(),
                  athleteId: athlete.id,
                ),
                child: SellDialog(
                  athlete: athlete,
                  athleteName: athlete.name,
                  aptPrice: athlete.longTokenBookPrice!,
                  isLongApt: isLongApt,
                  athleteId: athlete.id,
                  goToTradePage: goToTradePage,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text('Sell', style: textStyle(Colors.black, 20, false, false)),
      ),
    );
  }
}

class MintButton extends StatelessWidget {
  const MintButton({
    super.key,
    required this.athlete,
    required this.isPortraitMode,
    required this.containerWdt,
    required this.goToTradePage,
    required this.goToPage,
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;
  final void Function() goToTradePage;
  final void Function(int page) goToPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) => MintDialogBloc(
                  tokensRepository: context.read<TokensRepository>(),
                  getTotalTokenBalanceUseCase: GetTotalTokenBalanceUseCase(
                    walletRepository: context.read<WalletRepository>(),
                    tokensRepository: context.read<TokensRepository>(),
                  ),
                  lspController: Get.find(),
                  athleteId: athlete.id,
                  supportedSport: athlete.sport,
                ),
                child: MintDialog(
                  athlete: athlete,
                  goToTradePage: goToTradePage,
                  goToPage: goToPage,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child:
            Text('Mint Pair', style: textStyle(Colors.white, 20, false, false)),
      ),
    );
  }
}

class RedeemButton extends StatelessWidget {
  const RedeemButton({
    super.key,
    required this.athlete,
    required this.inputLongApt,
    required this.inputShortApt,
    required this.valueInAX,
    required this.isPortraitMode,
    required this.containerWdt,
    required this.goToTradePage,
  });

  final AthleteScoutModel athlete;
  final String inputLongApt;
  final String inputShortApt;
  final String valueInAX;
  final bool isPortraitMode;
  final double containerWdt;
  final void Function() goToTradePage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
      height: 50,
      decoration: boxDecoration(Colors.transparent, 100, 2, Colors.white),
      child: TextButton(
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) => RedeemDialogBloc(
                  tokensRepository: context.read<TokensRepository>(),
                  getTotalTokenBalanceUseCase: GetTotalTokenBalanceUseCase(
                    walletRepository: context.read<WalletRepository>(),
                    tokensRepository: context.read<TokensRepository>(),
                  ),
                  lspController: Get.find(),
                  athleteId: athlete.id,
                  supportedSport: athlete.sport,
                ),
                child: RedeemDialog(
                  athlete,
                  athlete.sport.toString(),
                  inputLongApt,
                  inputShortApt,
                  valueInAX,
                  goToTradePage,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Text(
          'Redeem Pair',
          style: textStyle(Colors.white, 20, false, false),
        ),
      ),
    );
  }
}
