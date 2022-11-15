import 'package:ax_dapp/service/custom_styles.dart';
import 'package:flutter/material.dart';

class MarketPriceImpact extends StatelessWidget {
  const MarketPriceImpact({
    super.key,
    required this.priceImpact,
  });

  final String priceImpact;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Market Price Impact:',
            style: textStyle(
              Colors.grey[600]!,
              15,
              isBold: false,
              isUline: false,
            ),
          ),
          Text(
            '$priceImpact %',
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
