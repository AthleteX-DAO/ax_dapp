import 'package:ax_dapp/util/chain_localized_image.dart';
import 'package:ax_dapp/util/chain_localized_name.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTopBarDetails extends StatelessWidget {
  const WalletTopBarDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showIcon = width >= 650;
    return TextButton(
      onPressed: () => Scaffold.of(context).openEndDrawer(),
      child: BlocBuilder<WalletBloc, WalletState>(
        buildWhen: (previous, current) =>
            previous.walletAddress != current.walletAddress ||
            previous.walletBalance != current.walletBalance ||
            previous.chain != current.chain,
        builder: (_, state) {
          final address = state.walletAddress;
          final hasAddress = address.isNotEmpty;
          final shortAddress = hasAddress
              ? '${address.substring(0, 7)}...${address.substring(address.length - 5)}'
              : 'Connect wallet';
          final isUnknownChain = state.chain == EthereumChain.none ||
              state.chain == EthereumChain.unsupported;
          final chainLabel =
              isUnknownChain ? 'Unknown network' : state.chain.localizedName;
          final balanceText = state.walletBalance > 0
              ? '${state.walletBalance.toStringAsFixed(2)} USDC'
              : 'USDC 0.00';

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ),
                if (!isUnknownChain)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Image.asset(
                      state.chain.localizedImage,
                      width: 16,
                      height: 16,
                    ),
                  ),
                Text(
                  chainLabel,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 16,
                  width: 1,
                  color: Colors.white24,
                ),
                const SizedBox(width: 8),
                Text(
                  shortAddress,
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  balanceText,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontFamily: 'OpenSans',
                    fontSize: 11,
                  ),
                ),
                if (hasAddress)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: address));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Address copied')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
