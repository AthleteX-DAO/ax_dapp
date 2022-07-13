import 'package:flutter/material.dart';

class FilterMenuError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'Athletes not supported yet',
        style: TextStyle(color: Colors.red, fontSize: 30),
      ),
    );
  }
}