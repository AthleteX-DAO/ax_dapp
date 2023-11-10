import 'package:flutter/material.dart';

class PredictionLoadingStatus extends StatelessWidget {
  const PredictionLoadingStatus({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 400,
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 30,
          fontFamily: 'OpenSans',
        ),
      ),
    );
  }
}
