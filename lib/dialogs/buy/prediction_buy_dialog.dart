import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/dialogs/buy/widgets/widgets.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/confirmation_dialogs/custom_confirmation_dialogs.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/util/warning_text_button.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyPredictionDialog extends StatelessWidget {
  BuyPredictionDialog({super.key, required this.predictionModel});

  final PredictionModel predictionModel;

  double paddingHorizontal = 20;
  double hgt = 500;
  final TextEditingController _predictionAmountController =
      TextEditingController();

  double slippageTolerance = 1;

  @override
  Widget build(BuildContext context) {
    var isWeb = true;
    isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);
    final _height = MediaQuery.of(context).size.height;
    final wid = isWeb ? 400.0 : 355.0;
    var hgt = 500.0;
    if (_height < 505) hgt = _height;
    return BlocConsumer<BuyDialogBloc, BuyDialogState>(
      listenWhen: (_, current) =>
          current.status == BlocStatus.error ||
          current.status == BlocStatus.noData,
      listener: (context, state) {
        if (state.status == BlocStatus.noData) {
          context.showWarningToast(
            title: 'No Data for Prediction',
            description: state.errorMessage,
          );
        } else {
          context.showWarningToast(
            title: 'Action Error',
            description: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<BuyDialogBloc>();
        final balance = state.balance;
        final minReceived = state.aptBuyInfo.minimumReceived.toStringAsFixed(6);
        final priceImpact = state.aptBuyInfo.priceImpact.toStringAsFixed(6);
        final totalFee = state.aptBuyInfo.totalFee;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
            height: hgt,
            width: wid,
            decoration: boxDecoration(Colors.grey[900]!, 30, 0, Colors.black),
          ),
        );
      },
    );
  }
}
