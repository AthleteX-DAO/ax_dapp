import 'package:ax_dapp/wallet/widgets/wallet_account.dart';
import 'package:ax_dapp/wallet/widgets/wallet_ax.dart';
import 'package:ax_dapp/wallet/widgets/wallet_chain.dart';
import 'package:ax_dapp/wallet/widgets/wallet_matic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Previously known as the "account box".
class WalletProfile extends StatelessWidget {
  const WalletProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    var width = 500.0;
    var showMatic = true;
    var showChain = true;

    if (_width < 835) {
      showMatic = false;
      width = 350;
    }
    if (_width < 825) {
      width = 510;
    }
    if (_width < 665) {
      showChain = false;
      width = 210;
    }

    final isWeb =
        kIsWeb && (MediaQuery.of(context).orientation == Orientation.landscape);

    return Container(
      height: isWeb ? 30 : 40,
      width: width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[400]!, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (showChain) const WalletChain(),
          if (showMatic) const WalletMatic(),
          const WalletAx(),
          const WalletAccount(),
        ],
      ),
    );
  }
}
