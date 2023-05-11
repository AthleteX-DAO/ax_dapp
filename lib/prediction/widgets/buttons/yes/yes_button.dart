import 'package:ax_dapp/prediction/widgets/buttons/yes/bloc/yes_button_bloc.dart';
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
      create: (context) => YesButtonBloc(),
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
                  bloc.add(const YesButtonPressed());
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
