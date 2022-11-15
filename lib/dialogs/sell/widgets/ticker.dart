import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class Ticker extends StatelessWidget {
  const Ticker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SellDialogBloc, SellDialogState>(
      buildWhen: (previous, current) =>
          previous.aptTypeSelection != current.aptTypeSelection ||
          previous.longApt != current.longApt ||
          previous.shortApt != current.shortApt,
      builder: (context, state) {
        final _textStyle = textStyle(
          Colors.white,
          15,
          isBold: false,
          isUline: false,
        );
        return Text(
          state.aptTypeSelection.isLong
              ? '''${state.longApt.ticker} APT'''
              : '''${state.shortApt.ticker} APT''',
          style: _textStyle,
        );
      },
    );
  }
}