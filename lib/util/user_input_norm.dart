import 'package:shared/shared.dart';

// Use this function to convert user input(double) into BigInt.

// BigInts are used to make web3(specifically transaction) calls.
// Parsing straight from double to BigInt floors the double
// (ex. BigInt.from(0.0001) == 0).
// Instead, parse the double into Decimal(keeps floating point)
// and add 18 zeros by multiplying with quintillion
// (10^18 == Decimal.fromInt(10).pow(18)).
// return BigInt from the obtained decimal

// Example: normalizeInput(0.001) = 1000000000000000

// Assumption: input has less than 18 digits after the floating point.

/// Converts a double(user input) into BigInt. Does NOT round double while
/// converting.
BigInt normalizeInput(double input, {int? decimal}) {
  final inDecimal = Decimal.parse(input.toString()) *
      Decimal.fromInt(10).pow(decimal ?? 18).toDecimal();
  return inDecimal.toBigInt();
}

BigInt getRawAmount(String input, int decimals) {
  final inDecimal =
      Decimal.parse(input) * Decimal.fromInt(10).pow(decimals).toDecimal();
  return inDecimal.toBigInt();
}

/// Converts a BigInt to String. round double while converting
String getViewAmount(BigInt input, int decimals) {
  final inDecimal = (Decimal.fromBigInt(input) /
          Decimal.fromInt(10).pow(decimals).toDecimal())
      .toDecimal();
  return inDecimal.toStringAsFixed(6);
}

/// Converts a BigInt rawAmount to double amount
double getAmountWithDecimal(BigInt amount, BigInt decimals) {
  final inDecimal = (Decimal.fromBigInt(amount) /
          Decimal.fromInt(10).pow(decimals.toInt()).toDecimal())
      .toDouble();
  return inDecimal;
}
