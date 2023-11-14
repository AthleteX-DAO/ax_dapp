import 'dart:math';

String toDecimal(double val, int decimal) {
  final num = val * (pow(10, decimal));
  final converted = num.truncate();
  final result = converted / (pow(10, decimal));
  return result.toString();
}
