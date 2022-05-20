import 'package:flutter/material.dart';

TextStyle textStyle(Color color, double size, bool isBold) {
  if (isBold)
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  else
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
    );
}
