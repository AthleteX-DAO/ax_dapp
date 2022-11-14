import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class LongBalance extends StatelessWidget {
  const LongBalance({
    super.key,
    required this.longBalance,
  });

  final double longBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Balance: $longBalance',
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
