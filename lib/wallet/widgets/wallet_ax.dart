import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/dialogs/your_ax_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletAx extends StatelessWidget {
  const WalletAx({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<WalletBloc>().add(const UpdateAxDataRequested());
        showDialog<void>(
          context: context,
          builder: (context) => const YourAXDialog(),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('../assets/images/X_white.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            'AX',
            style: TextStyle(
              color: Colors.grey[400],
              fontFamily: 'OpenSans',
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
