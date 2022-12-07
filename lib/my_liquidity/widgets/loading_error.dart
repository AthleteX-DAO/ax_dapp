import 'package:flutter/material.dart';

class LoadingError extends StatelessWidget {
  const LoadingError({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text(
          'Failed to load list of liquidity positions',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
