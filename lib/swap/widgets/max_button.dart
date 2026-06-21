import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/swap/bloc/swap_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaxButton extends StatelessWidget {
  const MaxButton({
    super.key,
    required this.bloc,
    required this.tokenFromBalance,
    required TextEditingController tokenFromInputController,
  }) : _tokenFromInputController = tokenFromInputController;

  final SwapPageBloc bloc;
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
          context.read<SwapPageBloc>() // Changed bloc ..add to context.read<SwapPageBloc>()
            ..add(MaxSwapTapEvent())
            ..add(
              NewTokenFromInputEvent(
                tokenInputFromAmount: double.parse(tokenFromBalance),
              ),
            );
          _tokenFromInputController.text = tokenFromBalance;
        },
        child: FittedBox(
          child: SizedBox(
            child: Text(
              'MAX',
              style: textStyle(
                Colors.grey[400]!,
                8,
                isBold: false,
                isUline: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
