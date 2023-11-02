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

  Widget cryptoDesktopMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          /// CryptoDesktopMarketsCard()
        },
      ),
    );
  }

  Widget cryptoMobileMarkets() {
    return SizedBox(
      height: constraints.maxHeight * 0.8 - 120,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          /// CryptoMobileMarketsCard()
        },
      ),
    );
  }

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
