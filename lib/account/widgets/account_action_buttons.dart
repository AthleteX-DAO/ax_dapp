import 'package:ax_dapp/account/bloc/account_bloc.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/usecases/explorer_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WalletActionButtons extends StatelessWidget {
  const WalletActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final walletAddress =
        context.select((WalletBloc bloc) => bloc.state.walletAddress);
    final chain = context.select((WalletBloc bloc) => bloc.state.chain);
    final explorerUseCase =
        ExplorerUseCase(walletAddress: walletAddress, chain: chain);
    final buttonMessage = explorerUseCase.buttonMessage(chain);
    final explorerUrl = explorerUseCase.explorerUrl(chain);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.arrow_downward_outlined,
          ),
          tooltip: 'Withdraw your crypto',
          onPressed: () {
            context.read<AccountBloc>().add(
                  const AccountWithdrawViewRequested(),
                );
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_upward_outlined),
          tooltip: 'Deposit your crypto ',
          onPressed: () {
            //Opens a new view for deposits
            context.read<AccountBloc>().add(
                  const AccountDepositViewRequested(),
                );
          },
        ),
        IconButton(
          icon: const Icon(Icons.payments_sharp),
          tooltip: 'Buy or Sell your USDC',
          onPressed: () {
            //Opens a new view for Buying and selling
            context.read<AccountBloc>().add(
                  const AccountBuyAndSellViewRequested(),
                );
          },
        ),
        IconButton(
          icon: const Icon(Icons.receipt_rounded),
          tooltip: buttonMessage,
          onPressed: () {
            launchUrl(Uri.parse(explorerUrl));
          },
        ),
      ],
    );
  }
}
