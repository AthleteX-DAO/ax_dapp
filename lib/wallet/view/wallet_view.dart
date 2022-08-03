import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';

class WalletView extends StatelessWidget {
  const WalletView({
    super.key,
    required this.controller,
    required this.walletController,
  });

  final Controller controller;
  final WalletController walletController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listener: (_, state) {
        if (state.isWalletUnavailable) {
          showDialog<void>(
            context: context,
            builder: (_) => const ConnectMetaMaskDialog(),
          );
        }
        if (state.isWalletUnsupported) {
          showDialog<void>(
            context: context,
            builder: (_) => const WrongNetworkDialog(),
          );
        }
        if (state.isWalletConnected) {
          final chainToken = context.read<TokensRepository>().chainToken;
          // TODO(Rolly): expose from wallet repository
          walletController
            ..getTokenMetrics()
            ..getYourAxBalance(chainToken.address);
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        if (state.isWalletConnected) {
          return WalletProfile(controller: controller);
        }
        return const ConnectWalletButton();
      },
    );
  }
}
