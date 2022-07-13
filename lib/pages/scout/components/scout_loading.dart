import 'package:flutter/material.dart';

class ScoutLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(
        color: Colors.amber,
      ),
    );
  }
}