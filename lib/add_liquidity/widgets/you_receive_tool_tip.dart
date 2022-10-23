import 'package:flutter/material.dart';

class YouReceiveToolTip extends StatelessWidget {
  const YouReceiveToolTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      height: 50,
      padding: const EdgeInsets.all(10),
      verticalOffset: -60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      richMessage: TextSpan(
        text:
            '''*Output is estimated. If the price changes by more than 2%, your transaction will revert.''',
        style: TextStyle(color: Colors.grey[400], fontSize: 18),
      ),
      child: const Icon(
        Icons.info_outline_rounded,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}
