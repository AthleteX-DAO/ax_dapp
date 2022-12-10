import 'package:flutter/material.dart';

TextStyle textStyle(
  Color color,
  double size, {
  required bool isBold,
  required bool isUline,
}) {
  return TextStyle(
    color: color,
    fontFamily: 'OpenSans',
    fontSize: size,
    fontWeight: isBold ? FontWeight.w400 : FontWeight.normal,
    decoration: isUline ? TextDecoration.underline : TextDecoration.none,
  );
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

TextStyle textSwapState({
  required bool condition,
  required TextStyle tabNotSelected,
  required TextStyle tabSelected,
}) {
  if (condition) return tabSelected;
  return tabNotSelected;
}
