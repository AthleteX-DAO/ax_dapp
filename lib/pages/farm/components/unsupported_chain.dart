import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';

Widget unsupported(EthereumChain chain) {
  return Center(
    child: SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'Farms support for ${chain.chainName} coming soon!',
        style: const TextStyle(color: Colors.blueAccent, fontSize: 30),
      ),
    ),
  );
}
