import 'package:auto_size_text/auto_size_text.dart';
import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/dialogs/mint/bloc/mint_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/mint/mint_dialog.dart';
import 'package:ax_dapp/dialogs/redeem/bloc/redeem_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/redeem/redeem_dialog.dart';
import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/sell/sell_dialog.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_sell_info_use_case.dart';
import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/service/controller/scout/long_short_pair_repository.dart.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;
  final bool isLongApt;

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
                  swapRepository: context.read<SwapRepository>(),
                  athleteId: athlete.id,
                ),
                child: BuyDialog(
                  athlete: athlete,
                  athleteName: athlete.name,
                  aptPrice: athlete.longTokenBookPrice!,
                  athleteId: athlete.id,
                  isLongApt: isLongApt,
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
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;
  final bool isLongApt;

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
                  swapRepository: context.read<SwapRepository>(),
                  athleteId: athlete.id,
                ),
                child: SellDialog(
                  athlete: athlete,
                  athleteName: athlete.name,
                  aptPrice: athlete.longTokenBookPrice!,
                  isLongApt: isLongApt,
                  athleteId: athlete.id,
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
  });

  final AthleteScoutModel athlete;
  final bool isPortraitMode;
  final double containerWdt;

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
                  longShortPairRepository:
                      context.read<LongShortPairRepository>(),
                  athleteId: athlete.id,
                  supportedSport: athlete.sport,
                ),
                child: MintDialog(
                  athlete: athlete,
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
  });

  final AthleteScoutModel athlete;
  final String inputLongApt;
  final String inputShortApt;
  final String valueInAX;
  final bool isPortraitMode;
  final double containerWdt;

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
                  longShortPairRepository:
                      context.read<LongShortPairRepository>(),
                  athleteId: athlete.id,
                  supportedSport: athlete.sport,
                ),
                child: RedeemDialog(
                  athlete,
                  athlete.sport.toString(),
                  inputLongApt,
                  inputShortApt,
                  valueInAX,
                ),
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: AutoSizeText(
          'Redeem Pair',
          style: textStyle(Colors.white, 20, false, false),
          maxLines: 1,
        ),
      ),
    );
  }
}

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
                      onPressed: () async {
                        print('pressed!');
                      },
                      child: const Text('Press Me'),
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
                    child: TextButton(
                      onPressed: () async {
                        print('pressed!');
                      },
                      child: const Text('Press Me'),
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
                  child: TextButton(
                    onPressed: () async {
                      print('pressed!');
                    },
                    child: const Text('Press Me'),
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
                  child: TextButton(
                    onPressed: () async {
                      print('pressed!');
                    },
                    child: const Text('Press Me'),
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
