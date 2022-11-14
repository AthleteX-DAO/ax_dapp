import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class ReceiveAmount extends StatelessWidget {
  const ReceiveAmount({
    super.key,
    required this.receiveAmount,
  });

  final double receiveAmount;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Receive: ',
            style: textStyle(
              Colors.white,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Row(
            children: [
              Text(
                '''$receiveAmount AX''',
                style: textStyle(
                  Colors.white,
                  15,
                  isBold: false,
                  isUline: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
