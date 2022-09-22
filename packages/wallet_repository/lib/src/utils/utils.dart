import 'package:decimal/decimal.dart';

/// Converts a BigInt rawAmount to double amount
double getAmountWithDecimal(BigInt amount, BigInt decimals) {
  final inDecimal = Decimal.fromBigInt(amount).toDouble() /
      Decimal.fromInt(10).pow(decimals.toInt()).toDouble();
  return inDecimal;
}
