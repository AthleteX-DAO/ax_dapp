import 'package:ax_dapp/service/dialog.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletAccount extends StatelessWidget {
  const WalletAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => const AccountDialog(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.grey,
          ),
          BlocSelector<WalletBloc, WalletState, String>(
            selector: (state) => state.walletAddress,
            builder: (_, walletAddress) {
              var formattedWalletAddress = '';
              if (walletAddress.isNotEmpty) {
                final walletAddressPrefix = walletAddress.substring(0, 7);
                final walletAddressSuffix = walletAddress.substring(
                  walletAddress.length - 5,
                  walletAddress.length,
                );
                formattedWalletAddress =
                    '$walletAddressPrefix...$walletAddressSuffix';
              }
              return Text(
                formattedWalletAddress,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                  fontSize: 11,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
