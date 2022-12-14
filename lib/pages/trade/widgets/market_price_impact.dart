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
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
            ),
          ),
          Text(
            '$priceImpact %',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }
}
