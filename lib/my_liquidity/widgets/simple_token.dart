import 'package:flutter/material.dart';

class SimpleToken extends StatelessWidget {
  const SimpleToken({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        symbol,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
