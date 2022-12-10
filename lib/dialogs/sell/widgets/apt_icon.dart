import 'package:ax_dapp/dialogs/sell/bloc/sell_dialog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokens_repository/tokens_repository.dart';

class AptIcon extends StatelessWidget {
  const AptIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final aptTypeSelection =
        context.select((SellDialogBloc bloc) => bloc.state.aptTypeSelection);
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          scale: 0.5,
          image: aptTypeSelection.isLong
              ? const AssetImage(
                  'assets/images/apt_noninverted.png',
                )
              : const AssetImage(
                  'assets/images/apt_inverted.png',
                ),
        ),
      ),
    );
  }
}
