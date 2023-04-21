import 'package:flutter/material.dart';

class Prompt extends StatelessWidget {
  const Prompt({super.key, required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    return Text(prompt);
  }
}
