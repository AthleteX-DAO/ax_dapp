import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletMatic extends StatelessWidget {
  const WalletMatic({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () =>
          context.read<WalletBloc>().add(const GetGasPriceRequested()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Icon(
            Icons.local_gas_station,
            color: Colors.grey,
          ),
          BlocSelector<WalletBloc, WalletState, double>(
            selector: (state) => state.gasPrice,
            builder: (_, gasPrice) {
              return Text(
                '$gasPrice gwei',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontFamily: 'OpenSans',
                  fontSize: 11,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
