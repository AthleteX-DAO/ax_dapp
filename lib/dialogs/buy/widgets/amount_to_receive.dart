import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AmountToReceive extends StatelessWidget {
  const AmountToReceive({super.key});

  @override
  Widget build(BuildContext context) {
    final _textStyle = textStyle(
      Colors.white,
      15,
      isBold: false,
      isUline: false,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('You Receive:', style: _textStyle),
        BlocBuilder<BuyDialogBloc, BuyDialogState>(
          builder: (context, state) {
            final amountToReceive =
                state.aptBuyInfo.receiveAmount.toStringAsFixed(6);
            return state.aptTypeSelection.isLong
                ? Text(
                    '$amountToReceive ${state.longApt.ticker} APT',
                    style: _textStyle,
                  )
                : Text(
                    '$amountToReceive ${state.shortApt.ticker} APT',
                    style: _textStyle,
                  );
          },
        )
      ],
    );
  }
}
