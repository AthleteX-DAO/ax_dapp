import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class WalletAssetCard extends StatelessWidget {
  const WalletAssetCard({
    super.key,
    required this.tokenAsset,
  });

  final Token tokenAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Your Asset: ${tokenAsset.name}'),
          ],
        ),
      ),
    );
  }
}
