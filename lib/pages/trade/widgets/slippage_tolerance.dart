import 'package:flutter/material.dart';

class SlippageTolerance extends StatelessWidget {
  const SlippageTolerance({
    super.key,
    required this.slippageTolerance,
  });

  final int slippageTolerance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Slippage Tolerance:',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '$slippageTolerance %',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}