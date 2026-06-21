import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';

class LPFee extends StatelessWidget {
  const LPFee({
    super.key,
    required this.tokenFrom,
    required this.lpFee,
  });

  final Token tokenFrom;
  final String lpFee;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Fees',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontFamily: 'OpenSans',
            ),
          ),
          Text(
            '$lpFee ${tokenFrom.ticker}',
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
