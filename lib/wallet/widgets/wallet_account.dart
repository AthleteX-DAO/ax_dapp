import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/dialog.dart';
import 'package:flutter/material.dart';

class WalletAccount extends StatelessWidget {
  const WalletAccount({super.key, required this.controller});

  final Controller controller;

  @override
  Widget build(BuildContext context) {
    final publicAddressHex = controller.publicAddress.value.toString();
    final addressPrefix = publicAddressHex.substring(0, 7);
    final addressSuffix = publicAddressHex.substring(
      publicAddressHex.length - 5,
      publicAddressHex.length,
    );
    final formattedAddressHex = publicAddressHex.length > 15
        ? '$addressPrefix...$addressSuffix'
        : publicAddressHex;

    return TextButton(
      onPressed: () => showDialog<void>(
        context: context,
        builder: accountDialog,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.account_balance_wallet,
            color: Colors.grey,
          ),
          Text(
            formattedAddressHex,
            style: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
