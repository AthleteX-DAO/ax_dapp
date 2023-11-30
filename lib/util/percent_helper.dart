import 'package:flutter/material.dart';

String getPercentageDesc(double percentage) {
  var sign = '';
  if (percentage > 0) {
    sign = '+';
  } else if (percentage < 0) {
    sign = '-';
  }

  return '$sign${percentage.abs().toStringAsFixed(2)}%';
}

Color getPercentageColor(double percentage) {
  if (percentage > 0) {
    return Colors.green;
  } else if (percentage < 0) {
    return Colors.red;
  } else {
    return Colors.white;
  }
}

IconData getPercentStatusIcon(double percentage) {
  if (percentage > 0) {
    return Icons.trending_up;
  } else if (percentage < 0) {
    return Icons.trending_down;
  } else {
    return Icons.trending_neutral;
  }
}
