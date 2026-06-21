import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  const Balance({super.key, required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        'Balance: $balance',
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
