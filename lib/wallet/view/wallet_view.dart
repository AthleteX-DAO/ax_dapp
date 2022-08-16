import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      listenWhen: (previous, current) =>
          previous.walletStatus != current.walletStatus ||
          previous.failure != current.failure,
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
      buildWhen: (previous, current) =>
          previous.walletStatus != current.walletStatus,
      builder: (_, state) {
        if (state.isWalletConnected) {
          return const WalletProfile();
        }
        return const ConnectWalletButton();
      },
    );
  }
}
