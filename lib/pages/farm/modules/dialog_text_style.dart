import 'package:flutter/material.dart';

// ignore: avoid_positional_boolean_parameters
TextStyle textStyle(Color color, double size, bool isBold) {
  if (isBold) {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  } else {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
    );
  }
}
