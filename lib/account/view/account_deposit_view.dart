import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDepositView extends StatelessWidget {
  const AccountDepositView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => context.read<AccountBloc>().add(
                const AccountDetailsViewRequested(),
              ),
        ),
      ],
    );
  }
}
