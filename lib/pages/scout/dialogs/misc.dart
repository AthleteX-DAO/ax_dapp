import 'package:flutter/material.dart';
export 'package:flutter/services.dart';

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

BoxDecoration boxDecoration(
    Color col, double rad, double borWid, Color borCol) {
  return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(rad),
      border: Border.all(color: borCol, width: borWid));
}
