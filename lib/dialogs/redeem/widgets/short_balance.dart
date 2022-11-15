import 'package:ax_dapp/service/custom_styles.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:flutter/material.dart';

class ShortBalance extends StatelessWidget {
  const ShortBalance({
    super.key,
    required this.shortBalance,
  });

  final double shortBalance;

  @override
  Widget build(BuildContext context) {
    final balance = toDecimal(shortBalance, 6);
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Balance: $balance',
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
