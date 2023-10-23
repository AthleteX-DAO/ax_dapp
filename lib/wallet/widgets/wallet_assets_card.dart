import 'package:flutter/material.dart';

class WalletAssetCard extends StatelessWidget {
  const WalletAssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SizedBox(
        height: 70,
        child: OutlinedButton(
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AssetImage'),
              Text('AssetName'),
              Text('Quantity & price'),
            ],
          ),
        ),
      );
    });
  }
}
