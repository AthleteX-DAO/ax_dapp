import 'package:flutter/material.dart';

Widget noData() {
  return const Center(
    child: SizedBox(
      height: 70,
      width: 320,
      child: Text(
        'No Farms to Display.',
        style: TextStyle(color: Colors.amber, fontSize: 30),
      ),
    ),
  );
}
