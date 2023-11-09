import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletBalance extends StatelessWidget {
  const WalletBalance({super.key});

  @override
  Widget build(BuildContext context) {
    const chain = EthereumChain.none;
    var walletBalance = 0.0;
    final isConnected =
        context.select((WalletBloc bloc) => bloc.state.isWalletConnected);
    final currentChain = context.select((WalletBloc bloc) => bloc.state.chain);
    if (isConnected && chain != currentChain) {
      context.read<WalletBloc>().add(const FetchWalletBalanceRequested());
      walletBalance =
          context.select((WalletBloc bloc) => bloc.state.walletBalance);
    }

    return TextButton(
      onPressed: () {
        context.read<WalletBloc>().add(const FetchWalletBalanceRequested());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.attach_money,
            color: Colors.white,
          ),
          Text(
            '$walletBalance',
            style: textStyle(
              Colors.white,
              20,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
