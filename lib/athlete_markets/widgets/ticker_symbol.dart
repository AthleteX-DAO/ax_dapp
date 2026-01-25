import 'package:flutter/material.dart';

class TickerSymbol extends StatelessWidget {
  const TickerSymbol({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Text(
      symbol,
      style: const TextStyle(color: Colors.white),
    );
  }
}
