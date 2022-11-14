import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  const Balance({
    super.key,
    required this.balance,
  });

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Balance: ${toDecimal(balance, 6)}',
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
