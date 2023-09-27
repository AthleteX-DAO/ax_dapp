import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SportsPage extends StatelessWidget {
  const SportsPage({
    super.key,
    required this.sport,
  });

  final SportsMarketsModel? sport;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 70,
      child: OutlinedButton(
        onPressed: () {
          final walletAddress =
              context.read<WalletBloc>().state.formattedWalletAddress;
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }
}
