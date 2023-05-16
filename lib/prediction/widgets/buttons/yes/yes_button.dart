import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/yes/bloc/yes_button_bloc.dart';
import 'package:ax_dapp/repositories/subgraph/usecases/get_buy_info_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => YesButtonBloc(
        repo: RepositoryProvider.of<GetBuyInfoUseCase>(
          context,
        ),
        eventMarketRepository: context.read<EventMarketRepository>(),
      ),
      child: BlocConsumer<YesButtonBloc, YesButtonState>(
        builder: (context, state) {
          final bloc = context.read<YesButtonBloc>();
          return Container(
            width: isPortraitMode ? containerWdt / 3 : 175,
            height: 50,
            // if portrait mode, use 1/3 of container width
            decoration:
                boxDecoration(primaryOrangeColor, 100, 0, primaryWhiteColor),
            child: TextButton(
              onPressed: () {
                final isWalletConnected =
                    context.read<WalletBloc>().state.isWalletConnected;
                if (isWalletConnected) {
                  bloc.add(
                    YesButtonPressed(
                      eventMarketAddress: prompt.address,
                      longTokenAddress: prompt.yesTokenAddress,
                    ),
                  );
                } else {
                  context.showWalletWarningToast();
                }
              },
              child:
                  Text('Yes', style: textStyle(Colors.black, 20, false, false)),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
