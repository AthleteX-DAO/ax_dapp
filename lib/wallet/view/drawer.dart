import 'package:ax_dapp/util/util.dart';
import 'package:ax_dapp/wallet/view/signup.dart';
import 'package:ax_dapp/wallet/wallet.dart';
import 'package:ax_dapp/wallet/widgets/account.dart';
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
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (BuildContext context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (state.status == WalletViewStatus.profile)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Account(),
                  ],
                ),
              if (state.status == WalletViewStatus.login) const LoginView(),
              if (state.status == WalletViewStatus.signup) const SignUpView(),
              if (state.status == WalletViewStatus.initial ||
                  state.status == WalletViewStatus.none)
                const LoginSignup(),
              const TermsAndConditions(),
              if (state.status == WalletViewStatus.loading)
                const Loader(
                  dimension: 80,
                ),
            ],
          );
        },
      ),
    );
  }
}
