import 'package:ethereum_api/tokens_api.dart';
import 'package:flutter/material.dart';

class Price extends StatelessWidget {
  const Price({
    super.key,
    required this.price,
    required this.tokenTo,
    required this.tokenFrom,
  });

  final String price;
  final Token tokenTo;
  final Token tokenFrom;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Price:',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
          Text(
            '$price ${tokenTo.ticker} per ${tokenFrom.ticker}',
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
