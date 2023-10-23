import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/wallet_assets_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletAssets extends StatelessWidget {
  const WalletAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Text('Your Wallet Assets'),
        ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            const WalletAssetCard();
          },
        ),
      ],
    );
  }
}
