import 'package:ax_dapp/wallet/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    // Returns The Signup & Login button together
    return Column(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: const [
        SignUpButton(),
        Login(),
      ],
    );
  }
}
