import 'package:flutter/material.dart';

class EmptyWallet extends StatelessWidget {
  const EmptyWallet({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: const Text(
          '''Connected wallet does not contain any Liquidity Tokens. You can get your positions on Add Liquidity page.''',
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
