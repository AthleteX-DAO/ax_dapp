import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectWalletButton extends StatelessWidget {
  const ConnectWalletButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isWalletConnected =
        context.select((WalletBloc bloc) => bloc.state.isWalletConnected);
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final _width = MediaQuery.of(context).size.width;
    var width = 180.0;
    var text = 'Connect';
    var formattedWalletAddress = '';
    if (walletAddress.isNotEmpty) {
      final walletAddressPrefix = walletAddress.substring(0, 7);
      final walletAddressSuffix = walletAddress.substring(
        walletAddress.length - 5,
        walletAddress.length,
      );
      formattedWalletAddress = '$walletAddressPrefix...$walletAddressSuffix';
    }
    if (_width < 565) {
      width = 110;
    }

    if (isWalletConnected) {
      text = formattedWalletAddress;
    }

    return Container(
      height: 37.5,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.amber[400]!, width: 2),
      ),
      child: TextButton(
        onPressed: () {
          Scaffold.of(context).openEndDrawer();
        },
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.amber[400],
              fontFamily: 'OpenSans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
