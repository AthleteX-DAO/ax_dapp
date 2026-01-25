import 'package:auto_size_text/auto_size_text.dart';
import 'package:ax_dapp/dialogs/modern_trading_dialog.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MintPredictionButton extends StatelessWidget {
  const MintPredictionButton({
    super.key,
    required this.prompt,
  });

  final PredictionModel prompt;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
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
    final _width = MediaQuery.sizeOf(context).width;
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
    this.initialOutcome = 'Yes',
  });

  final PredictionModel predictionModel;
  final bool isPortraitMode;
  final double containerWdt;
  final String initialOutcome;
  // final bool isLongApt;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryOrangeColor,
            primaryOrangeColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryOrangeColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;
          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) => ModernTradingDialog(
                predictionModel: predictionModel,
                isBuy: true,
                yesPrice: predictionModel.longTokenPrice ?? 0.0,
                noPrice: predictionModel.shortTokenPrice ?? 0.0,
                initialOutcome: initialOutcome,
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_shopping_cart,
              color: Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Buy',
              style: textStyle(
                Colors.black,
                16,
                isBold: true,
                isUline: false,
              ),
            ),
          ],
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
    this.initialOutcome = 'Yes',
  });

  final PredictionModel predictionModel;
  final bool isPortraitMode;
  final double containerWdt;
  final String initialOutcome;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryOrangeColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          final isWalletConnected =
              context.read<WalletBloc>().state.isWalletConnected;

          if (isWalletConnected) {
            showDialog<void>(
              context: context,
              builder: (context) => ModernTradingDialog(
                predictionModel: predictionModel,
                isBuy: false,
                yesPrice: predictionModel.longTokenPrice ?? 0.0,
                noPrice: predictionModel.shortTokenPrice ?? 0.0,
                initialOutcome: initialOutcome,
              ),
            );
          } else {
            context.showWalletWarningToast();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sell,
              color: Colors.black87,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Sell',
              style: textStyle(
                Colors.black87,
                16,
                isBold: true,
                isUline: false,
              ),
            ),
          ],
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
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          const urlString = 'https://oracle.uma.xyz/';
          launchUrl(Uri.parse(urlString));
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.gavel,
              color: Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 8),
            AutoSizeText(
              'Propose Resolution',
              style: textStyle(
                Colors.white,
                14,
                isBold: true,
                isUline: false,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
