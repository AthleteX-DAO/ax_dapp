import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/yes/bloc/yes_button_bloc.dart';
import 'package:ax_dapp/prediction/widgets/buttons/yes/yes_dialog.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_swap_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

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
    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    final invalidAddr = GoRouter.of(context).location.contains('prediction') &&
        prompt.yesTokenAddress.isEmpty;
    var hgt = 300.0;
    if (_height < 305) hgt = _height;
    return Container(
      width: isPortraitMode ? containerWdt / 3 : 175,
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
                  hgt: hgt,
                  wid: wid,
                  predictionModel: prompt,
                  isPortraitMode: isPortraitMode,
                  containerWdt: containerWdt,
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
