import 'package:ax_dapp/service/gold_theme.dart';
import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Standalone "Already have an account? Login" link text.
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontFamily: 'OpenSans',
          ),
        ),
        GestureDetector(
          onTap: () =>
              context.read<WalletBloc>().add(const LoginViewRequested()),
          child: const Text(
            'Log In',
            style: TextStyle(
              fontSize: 14,
              color: GoldTheme.gold,
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ],
    );
  }
}
