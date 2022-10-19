import 'package:ax_dapp/pages/trade/bloc/trade_page_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class MaxButton extends StatelessWidget {
  const MaxButton({
    super.key,
    required this.bloc,
    required this.tokenFromBalance,
    required TextEditingController tokenFromInputController,
  }) : _tokenFromInputController = tokenFromInputController;

  final TradePageBloc bloc;
  final String tokenFromBalance;
  final TextEditingController _tokenFromInputController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 40,
      decoration: boxDecoration(
        Colors.transparent,
        100,
        0.5,
        Colors.grey[400]!,
      ),
      child: TextButton(
        onPressed: () {
          bloc
            ..add(MaxSwapTapEvent())
            ..add(
              NewTokenFromInputEvent(
                tokenInputFromAmount: double.parse(tokenFromBalance),
              ),
            );
          _tokenFromInputController.text = tokenFromBalance;
        },
        child: Text(
          'MAX',
          style: textStyle(Colors.grey[400]!, 8, isBold: false),
        ),
      ),
    );
  }
}
