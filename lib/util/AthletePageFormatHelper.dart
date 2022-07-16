// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

TextStyle textStyle(Color color, double size, bool isBold, bool isUline) {
  // ignore: curly_braces_in_flow_control_structures
  if (isBold) if (isUline) {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.underline,
    );
  } else {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      fontWeight: FontWeight.w400,
    );
  }
  else if (isUline) {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
      decoration: TextDecoration.underline,
    );
  } else {
    return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: size,
    );
  }
}

BoxDecoration boxDecoration(
  Color col,
  double rad,
  double borWid,
  Color borCol,
) {
  return BoxDecoration(
    color: col,
    borderRadius: BorderRadius.circular(rad),
    border: Border.all(color: borCol, width: borWid),
  );
}
