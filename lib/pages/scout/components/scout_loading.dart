import 'package:flutter/material.dart';

class ScoutLoading extends StatelessWidget {
  const ScoutLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(
        color: Colors.amber,
      ),
    );
  }
}
