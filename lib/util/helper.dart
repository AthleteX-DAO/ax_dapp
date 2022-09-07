import 'dart:math';

const kDecimals = 18;

BigInt days(int x) {
  return BigInt.from(60 * 60 * 24 * x);
}

Future<DateTime> now() async {
  return DateTime.now();
}

String toDecimal(double val, int decimal) {
  final num = val * (pow(10, decimal));
  final converted = num.truncate();
  final result = converted / (pow(10, decimal));
  return result.toString();
}
