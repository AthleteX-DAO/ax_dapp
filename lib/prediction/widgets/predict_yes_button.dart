import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class PredictYesButton extends StatelessWidget {
  const PredictYesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.05,
      height: 36,
      decoration: boxDecoration(
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
        100,
        0,
        const Color.fromRGBO(
          254,
          197,
          0,
          0.2,
        ),
      ),
      child: TextButton(
        onPressed: () {
          debugPrint('yes');
        },
        child: TextButton(
          onPressed: () {
            debugPrint('yes');
          },
          child: const Text('Yes'),
        ),
      ),
    );
  }
}
