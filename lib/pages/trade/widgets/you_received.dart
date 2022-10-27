import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';

class YouReceived extends StatelessWidget {
  const YouReceived({
    super.key,
    required this.receiveAmount,
    required this.tokenTo,
  });

  final String receiveAmount;
  final Token tokenTo;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'You receive:',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Text(
            '$receiveAmount ${tokenTo.ticker}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}