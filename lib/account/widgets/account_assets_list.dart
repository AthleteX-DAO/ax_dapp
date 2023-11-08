import 'package:ax_dapp/account/widgets/widgets.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

class WalletAssetsList extends StatelessWidget {
  const WalletAssetsList({super.key, required BoxConstraints boxConstraints})
      : constraints = boxConstraints;

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final currentTokens = context.read<TokensRepository>().currentTokens;
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
