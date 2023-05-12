import 'package:ax_dapp/prediction/widgets/buttons/mint/bloc/mint_button_bloc.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/athlete_page_format_helper.dart';
import 'package:ax_dapp/util/colors.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/prediction/bloc/prediction_page_bloc.dart';
import 'package:ax_dapp/prediction/view/prediction_page.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';
import '';

class GenericMintButton extends StatelessWidget {
  const GenericMintButton({
    super.key,
    required this.isPortraitMode,
    required this.prompt,
    required this.containerWdt,
  });

  final bool isPortraitMode;
  final PredictionModel prompt;
  final double containerWdt;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MintButtonBloc(
        eventMarketRepository: context.read<EventMarketRepository>(),
        walletRepository: context.read<WalletRepository>(),
        streamAppDataChanges: context.read<StreamAppDataChangesUseCase>(),
      ),
      child: BlocConsumer<MintButtonBloc, MintButtonState>(
        builder: (context, state) {
          final bloc = context.read<MintButtonBloc>();
          return Container(
            width: isPortraitMode ? containerWdt / 3 : 175,
            height: 50,
            decoration: boxDecoration(primaryOrangeColor, 100, 0, Colors.green),
            child: TextButton(
              onPressed: () {
                bloc.add(
                  MintButtonPressed(
                    eventMarketAddress: prompt.address,
                  ),
                );
              },
              child: Text(
                'Mint',
                style: textStyle(Colors.black, 20, false, false),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
