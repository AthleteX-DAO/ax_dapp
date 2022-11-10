import 'package:flutter/material.dart';

Widget noWallet() {
  return const Center(
    child: SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'Please connect your wallet.',
        style: TextStyle(color: Colors.amber, fontSize: 30),
      ),
    ),
  );
}
