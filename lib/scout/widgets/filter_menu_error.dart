import 'package:flutter/material.dart';

class FilterMenuError extends StatelessWidget {
  const FilterMenuError({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 80,
      width: 600,
      child: Text(
        'Change to SX network for NFL Tokens',
        style: TextStyle(color: Colors.amber, fontSize: 30),
      ),
    );
  }
}
