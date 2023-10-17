import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    const textSize = 20.0;

    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              color: Colors.amber[400],
              fontSize: textSize,
              fontFamily: 'OpenSans',
            ),
          ),
          TextSpan(
            text: 'Login',
            style: const TextStyle(
              color: Colors.white,
              fontSize: textSize,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.read<WalletBloc>().add(const LoginViewRequested());
                context.read<WalletBloc>().add(const ConnectWalletRequested());
              },
          ),
        ],
      ),
    );
  }
}
