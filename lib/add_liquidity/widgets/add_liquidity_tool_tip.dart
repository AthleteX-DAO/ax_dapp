import 'package:flutter/material.dart';

class AddLiquidityToolTip extends StatelessWidget {
  const AddLiquidityToolTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      height: 50,
      padding: const EdgeInsets.all(10),
      verticalOffset: -100,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(25),
      ),
      richMessage: TextSpan(
        text:
            '''*Add liquidity to earn 0.25% of all trades on this pair proportional to your share of the pool and receive LP tokens.''',
        style: TextStyle(color: Colors.grey[400], fontSize: 18),
      ),
      child: const Icon(
        Icons.info_outline_rounded,
        color: Colors.grey,
        size: 25,
      ),
    );
  }
}
