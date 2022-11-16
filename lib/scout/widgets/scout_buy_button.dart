import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/buy_dialog.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/widgets/buy_text.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/toast_extensions.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

class ScoutBuyButton extends StatelessWidget {
  const ScoutBuyButton({
    required this.athlete,
    required this.isLongToken,
    super.key,
  });

  final AthleteScoutModel athlete;
  final bool isLongToken;

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
            builder: (
              BuildContext context,
            ) =>
                BlocProvider(
              create: (
                BuildContext context,
              ) =>
                  BuyDialogBloc(
                walletRepository: context.read<WalletRepository>(),
                streamAppDataChanges:
                    context.read<StreamAppDataChangesUseCase>(),
                tokensRepository: context.read<TokensRepository>(),
                repo: RepositoryProvider.of<GetBuyInfoUseCase>(
                  context,
                ),
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
                isLongApt: isLongToken,
              ),
            ),
          );
        },
        child: const BuyText(),
      ),
    );
  }
}
