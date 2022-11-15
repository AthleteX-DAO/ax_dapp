import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class YouReceived extends StatelessWidget {
  const YouReceived({
    super.key,
    required this.receiveAmount,
  });

  final String receiveAmount;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Receive:',
            style: textStyle(
              Colors.white,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$receiveAmount AX',
            style: textStyle(
              Colors.white,
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
