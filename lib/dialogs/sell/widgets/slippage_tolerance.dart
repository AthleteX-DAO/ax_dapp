import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class SlippageTolerance extends StatelessWidget {
  const SlippageTolerance({
    super.key,
    required this.slippageTolerance,
  });

  final double slippageTolerance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Slippage Tolerance:',
            style: textStyle(
              Colors.grey[600]!,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$slippageTolerance %',
            style: textStyle(
              Colors.grey[600]!,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
        ],
      ),
    );
  }
}
