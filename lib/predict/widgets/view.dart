import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ViewButton extends StatelessWidget {
  const ViewButton({
    required this.predictionModel,
    super.key,
  });

  final PredictionModel predictionModel;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final walletAddress =
            context.read<WalletBloc>().state.formattedWalletAddress;

        context.goNamed(
          'prediction',
          params: {
            'prompt': predictionModel.prompt,
            'details': predictionModel.details
          },
        );
      },
      child: SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'View',
              style: textStyle(
                Colors.white,
                16,
                isBold: false,
                isUline: false,
              ),
            ),
            const Icon(
              Icons.arrow_right,
              size: 25,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
