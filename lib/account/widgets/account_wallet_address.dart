import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class WalletAddress extends StatelessWidget {
  const WalletAddress({super.key});

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    var formattedWalletAddress = '';
    if (walletAddress.isNotEmpty) {
      final walletAddressPrefix = walletAddress.substring(0, 7);
      final walletAddressSuffix = walletAddress.substring(
        walletAddress.length - 5,
        walletAddress.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }
    return TextButton(
      onPressed: () {
        Clipboard.setData(
          ClipboardData(
            text: walletAddress,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
          ),
          Text(
            formattedWalletAddress,
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
