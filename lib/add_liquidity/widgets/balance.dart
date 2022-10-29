import 'package:flutter/material.dart';

class Balance extends StatelessWidget {
  const Balance({super.key, required this.balance});

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      alignment: Alignment.bottomRight,
      child: Text(
        'Balance: $balance',
        style: TextStyle(color: Colors.grey[400], fontSize: 13),
      ),
    );
  }
}
