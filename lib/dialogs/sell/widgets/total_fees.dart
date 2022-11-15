import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class TotalFees extends StatelessWidget {
  const TotalFees({
    super.key,
    required this.totalFee,
  });

  final double totalFee;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Fees:',
            style: textStyle(
              Colors.grey[600]!,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$totalFee APT(0.3%)',
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
