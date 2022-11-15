import 'package:ax_dapp/dialogs/buy/bloc/buy_dialog_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class Price extends StatelessWidget {
  const Price({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Price:',
          style: textStyle(
            Colors.white,
            15,
            isBold: false,
            isUline: false,
          ),
        ),
        BlocBuilder<BuyDialogBloc, BuyDialogState>(
          buildWhen: (previous, current) =>
              previous.aptTypeSelection != current.aptTypeSelection ||
              previous.aptBuyInfo != current.aptBuyInfo ||
              previous.longApt != current.longApt ||
              previous.shortApt != current.shortApt,
          builder: (context, state) {
            final price = state.aptBuyInfo.axPerAptPrice.toStringAsFixed(6);
            final _textStyle = textStyle(
              Colors.white,
              15,
              isBold: false,
              isUline: false,
            );
            return state.aptTypeSelection.isLong
                ? Text(
                    '$price AX per ${state.longApt.ticker} APT',
                    style: _textStyle,
                  )
                : Text(
                    '$price AX per ${state.shortApt.ticker} APT',
                    style: _textStyle,
                  );
          },
        )
      ],
    );
  }
}
