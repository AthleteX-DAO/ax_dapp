import 'package:flutter/material.dart';

String getPercentageDesc(double percentage) {
  String sign = "";
  if(percentage > 0)
    sign = "+";
  else if (percentage < 0)
    sign = "-";

  return "$sign ${percentage.abs().toStringAsFixed(2)}%";
}

Color getPercentageColor(double percentage) {
  if(percentage >= 0)
    return Colors.green;
  return Colors.red;
}