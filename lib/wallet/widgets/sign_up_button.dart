import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          Colors.amber[200]!.withOpacity(0.15),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        minimumSize: WidgetStateProperty.all<Size>(
          Size(width / 4, height * 0.09),
        ),
        maximumSize: WidgetStateProperty.all<Size>(
          Size(width / 2, height * 0.10),
        ),
      ),
      child: FittedBox(
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.amber[400],
            fontSize: 40,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onPressed: () {
        context.read<WalletBloc>().add(const SignUpViewRequested());
      },
    );
  }
}
