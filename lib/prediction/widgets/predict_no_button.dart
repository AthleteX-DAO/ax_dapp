import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PredictNoButton extends StatelessWidget {
  const PredictNoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.14,
      height: 36,
      decoration: boxDecoration(
        Colors.grey,
        100,
        0,
        Colors.white,
      ),
      child: TextButton(
        onPressed: () {
          debugPrint('no');
        },
        child: TextButton(
          onPressed: () {
            debugPrint('no');
          },
          child: const Text('No'),
        ),
      ),
    );
  }
}
