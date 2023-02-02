import 'package:flutter/material.dart';

class WalletMagic extends StatelessWidget {
  const WalletMagic({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // TODO(anyone): call [showWallet] from the magic repository
      onPressed: () => {},
      child: Text(
        'Show Wallet',
        style: TextStyle(fontFamily: 'OpenSans', color: Colors.grey[400]),
      ),
    );
  }
}
