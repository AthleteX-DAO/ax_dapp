import 'package:flutter/material.dart';

class CryptoMobileMarketsView extends StatelessWidget {
  const CryptoMobileMarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: _height * 0.8,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          /// CryptoMobileMarketsCard()
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
