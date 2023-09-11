import 'package:ax_dapp/service/tracking/tracking_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const startTradingTextSize = 20.0;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    const textSize = 14.0;
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
              fontFamily: 'OpenSans',
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.read<TrackingCubit>().onPressedStartTrading();
                context.goNamed('scout');
              },
          ),
        ],
      ),
    );
  }
}
