import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/wallet.dart';
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
      backgroundColor: Colors.black,
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (BuildContext context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (state.walletViewStatus == WalletViewStatus.profile)
                const Account(),
              if (state.walletViewStatus == WalletViewStatus.login)
                const LoginView(),
              if (state.walletViewStatus == WalletViewStatus.signup)
                const SignUpView(),
              if (state.walletViewStatus == WalletViewStatus.resetPassword)
                const ResetPasswordView(),
              if (state.walletViewStatus == WalletViewStatus.initial ||
                  state.walletViewStatus == WalletViewStatus.none)
                const LoginSignup(),
              const TermsAndConditions(),
              if (state.walletViewStatus == WalletViewStatus.loading)
                const Loader(
                  dimension: 80,
                ),
            ],
          );
        },
        buildWhen: (previous, current) {
          return previous.walletViewStatus != current.walletViewStatus;
        },
      ),
    );
  }
}
