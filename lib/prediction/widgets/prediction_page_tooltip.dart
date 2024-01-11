import 'package:flutter/material.dart';

class PredictionPageToolTip extends StatelessWidget {
  const PredictionPageToolTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 3),
      height: 20,
      preferBelow: true,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(50),
      ),
      richMessage: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Buy/Sell a prediction token at its market price',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
      child: const Icon(
        Icons.info_outline_rounded,
        color: Colors.grey,
        size: 25,
      ),
    );
  }
}
