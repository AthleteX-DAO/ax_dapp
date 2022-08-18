import 'package:flutter/material.dart';

class FilterMenuError extends StatelessWidget {
  const FilterMenuError({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'Athletes not supported yet',
        style: TextStyle(color: Colors.red, fontSize: 30),
      ),
    );
  }
}
