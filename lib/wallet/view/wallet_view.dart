import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key, required this.controller});

  final Controller controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
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
