import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';

class MinimumReceived extends StatelessWidget {
  const MinimumReceived({
    super.key,
    required this.minReceived,
    required this.tokenTo,
  });

  final String minReceived;
  final Token tokenTo;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Minimum Received:',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
          Text(
            '$minReceived ${tokenTo.ticker}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}