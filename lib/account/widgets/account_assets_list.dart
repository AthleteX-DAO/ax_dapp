import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletAssetsList extends StatelessWidget {
  const WalletAssetsList({super.key, required BoxConstraints boxConstraints})
      : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final currentTokens =
        context.select((WalletBloc bloc) => bloc.state.tokens);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: constraints.maxHeight * 0.5,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: currentTokens.length,
            itemBuilder: (context, index) {
              return AccountAssetCard(
                token: currentTokens[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
