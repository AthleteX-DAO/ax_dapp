import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletView extends StatelessWidget {
  const WalletView({
    super.key,
    required this.controller,
  });

  final Controller controller;

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
          final walletAddress = context.read<WalletBloc>().state.walletAddress;
          context.read<TrackingCubit>().onPressedConnectWallet(
                publicAddress: '"$walletAddress"',
              );
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
