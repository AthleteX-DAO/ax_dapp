import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountBuyAndSell extends StatelessWidget {
  const AccountBuyAndSell({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.read<AccountBloc>().add(
                const AccountDetailsViewRequested(),
              ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Buy and sell is available on the web version.',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
