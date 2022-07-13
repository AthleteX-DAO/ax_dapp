import 'package:ax_dapp/bloc/redeemBloc/redeem_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/Dialog.dart';

class ConfirmtransactionDialog extends StatelessWidget {
  const ConfirmtransactionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RedeemBloc, RedeemState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        if (state.sucessful == true) {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  confirmTransaction(context, true, ""));
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
