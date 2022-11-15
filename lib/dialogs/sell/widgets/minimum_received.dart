import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class MinimumReceived extends StatelessWidget {
  const MinimumReceived({
    super.key,
    required this.minReceived,
  });

  final String minReceived;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Minimum Received:',
            style: textStyle(
              Colors.grey[600]!,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$minReceived AX',
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
