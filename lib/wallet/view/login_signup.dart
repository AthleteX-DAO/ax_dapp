import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SignUpButton(),
        Login(),
      ],
    );
  }
}
