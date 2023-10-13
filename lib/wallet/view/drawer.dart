import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/view/signup.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:ax_dapp/wallet/widgets/account.dart';
import 'package:ax_dapp/wallet/widgets/login_text.dart';
import 'package:ax_dapp/wallet/widgets/sign_up_button.dart';
import 'package:ax_dapp/wallet/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Drawer(
      width: width < 769 ? width : width / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BlocConsumer<WalletBloc, WalletState>(
            listenWhen: (previous, current) =>
                previous.walletStatus != current.walletStatus ||
                previous.failure != current.failure,
            listener: (context, state) {
              if (state.isWalletUnsupported) {
                context.showWarningToast(
                  title: 'Wallet Not Supported!',
                  description: 'This wallet is currently not supported',
                );
              }
              if (state.isWalletUnavailable) {
                context.showWarningToast(
                  title: 'Wallet Unavailable',
                  description: 'This wallet type is currently unavailable.',
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.walletStatus != current.walletStatus,
            builder: (context, state) {
              if (state.status == WalletViewStatus.profile) {
                return const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Account(),
                  ],
                );
              }

              if (state.status == WalletViewStatus.login) {
                return const LoginView();
              }

              if (state.status == WalletViewStatus.signup) {
                return const SignUpView();
              }

              if (state.status == WalletViewStatus.loading) {
                return const Loader(
                  dimension: 80,
                );
              }

              if (state.status == WalletViewStatus.initial) {
                return const LoginSignup();
              }

              return const TermsAndConditions();
            },
          ),
        ],
      ),
    );
  }
}
