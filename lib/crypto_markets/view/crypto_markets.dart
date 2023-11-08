import 'package:flutter/material.dart';

class CryptoMarkets extends StatelessWidget {
  const CryptoMarkets({
    super.key,
    required List<String> filteredMarkets,
    required BoxConstraints boxConstraints,
  })  : cryptoMarkets = filteredMarkets,
        constraints = boxConstraints;

  final List<String> cryptoMarkets;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: const Center(
        child: SizedBox(
          height: 70,
          child: Text(
            'Check later for Crypto Markets!',
            style: TextStyle(
              color: Colors.yellow,
              fontSize: 30,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }
}
