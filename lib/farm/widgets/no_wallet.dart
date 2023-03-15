import 'package:flutter/material.dart';

class NoWallet extends StatelessWidget {
  const NoWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 70,
        child: Text(
          'Please connect your wallet.',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 30,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
