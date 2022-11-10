import 'package:flutter/material.dart';

Widget loadingError() {
  return const Center(
    child: SizedBox(
      height: 70,
      width: 400,
      child: Text(
        'Failed to load list of liquidity positions',
        style: TextStyle(color: Colors.red, fontSize: 30),
      ),
    ),
  );
}
