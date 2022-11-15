import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class YouSpend extends StatelessWidget {
  const YouSpend({super.key, required this.spendAmount});

  final double spendAmount;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You Spend:',
            style: textStyle(
              Colors.white,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$spendAmount AX',
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
