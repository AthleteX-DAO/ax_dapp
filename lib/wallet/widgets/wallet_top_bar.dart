import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletTopBar extends StatelessWidget {
  const WalletTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listenWhen: (previous, current) =>
          previous.axData == AxData.empty &&
          current.axData != AxData.empty &&
          current.isWalletConnected,
      listener: (context, state) {
        final walletAddress = context.read<WalletBloc>().state.walletAddress;
        context.read<TrackingCubit>().onConnectWalletSuccessful(
              publicAddress: walletAddress,
              axUnits: '"${toDecimal(state.axData.balance!, 6)} AX"',
              walletType: 'MetaMask',
            );
      },
      child: BlocConsumer<WalletBloc, WalletState>(
        listenWhen: (previous, current) =>
            previous.walletStatus != current.walletStatus ||
            previous.failure != current.failure,
        listener: (_, state) {
          if (state.isWalletUnsupported || state.isWalletUnavailable) {
            context.showWarningToast(
              title: 'Wallet Error',
              description: 'MetaMask is not Installed on Browser',
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.walletStatus != current.walletStatus,
        builder: (_, state) {
          if (state.isWalletConnected) {
            return const WalletTopBarDetails();
          }
          return const ConnectWalletButton();
        },
      ),
    );
  }
}
