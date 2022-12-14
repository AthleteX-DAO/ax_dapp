import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

class UnsupportedChain extends StatelessWidget {
  const UnsupportedChain({super.key, required this.chain});

  final EthereumChain chain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        width: 400,
        child: Text(
          'Farms support for ${chain.chainName} coming soon!',
          style: const TextStyle(color: Colors.blueAccent, fontSize: 30, fontFamily: 'OpenSans',),
        ),
      ),
    );
  }
}
