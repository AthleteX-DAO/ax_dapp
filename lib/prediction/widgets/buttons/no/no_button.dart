import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/widgets/buttons/no/bloc/no_button_bloc.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => NoButtonBloc(
        eventMarketRepository: context.read<EventMarketRepository>(),
      ),
      child: BlocConsumer<NoButtonBloc, NoButtonState>(
        builder: (context, state) {
          final bloc = context.read<NoButtonBloc>();

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
                  bloc.add(
                    NoButtonPressed(
                      eventMarketAddress: prompt.address,
                      shortTokenAddress: prompt.noTokenAddress,
                    ),
                  );
                } else {
                  context.showWalletWarningToast();
                }
              },
              child:
                  Text('No', style: textStyle(Colors.white, 20, false, false)),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
