import 'package:flutter/material.dart';

class InsufficientBalance extends StatelessWidget {
  const InsufficientBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amber),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const TextButton(
        onPressed: null,
        child: Text(
          'Insufficient Balance',
          style: TextStyle(
            fontSize: 16,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
