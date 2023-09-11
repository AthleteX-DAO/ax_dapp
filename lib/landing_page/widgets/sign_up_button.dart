import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  build(BuildContext context) {
    const startTradingTextSize = 20.0;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.amber[200]!.withOpacity(0.15),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(_width / 3, _height * 0.05),
        ),
        maximumSize: MaterialStateProperty.all<Size>(
          Size(_width / 2, _height * 0.06),
        ),
      ),
      onPressed: () {
        context.read<TrackingCubit>().onPressedStartTrading();
        context.goNamed('scout');
      },
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.amber[400],
          fontSize: startTradingTextSize,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
