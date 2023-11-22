import 'package:ax_dapp/athlete_markets/athlete.dart';
import 'package:ax_dapp/dialogs/buy/prediction_buy_dialog.dart';
import 'package:ax_dapp/dialogs/dialogs.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/controller/swap/swap_repository.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class PredictionBuyButton extends StatelessWidget {
  const PredictionBuyButton({
    super.key,
    required this.predictionModel,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
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
          final isWalletDisconnected =
              context.read<WalletBloc>().state.isWalletDisconnected;
          if (isWalletDisconnected) {
            context.showWalletWarningToast();
            return;
          }

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
        },
        child: const BuyText(),
      ),
    );
  }
}
