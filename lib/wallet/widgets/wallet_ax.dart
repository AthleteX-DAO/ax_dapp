import 'package:ax_dapp/service/dialog.dart';
import 'package:flutter/material.dart';

class WalletAx extends StatelessWidget {
  const WalletAx({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<void>(
        context: context,
        builder: yourAXDialog,
      ),
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
            'Ax',
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
