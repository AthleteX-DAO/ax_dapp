import 'package:decimal/decimal.dart';
import 'package:web3dart/web3dart.dart';

// Use this function to convert user input(double) into BigInt.

// BigInts are used to make web3(specifically transaction) calls.
// Parsing straight from double to BigInt floors the double (ex. BigInt.from(0.0001) == 0).
// Instead, parse the double into Decimal(keeps floating point)
// and add 18 zeros by multiplying with quintillion(10^18 == Decimal.fromInt(10).pow(18)).
// return BigInt from the obtained decimal

// Example: normalizeInput(0.001) = 1000000000000000

// Assumption: input has less than 18 digits after the floating point.

/// Converts a double(user input) into BigInt. Does NOT round double while converting.
BigInt normalizeInput(double input) {
  Decimal inDecimal =
      Decimal.parse(input.toString()) * Decimal.fromInt(10).pow(18);
  return inDecimal.toBigInt();
}

/// Converts a BigInt to double. round double while converting
double getEtherValue(BigInt input) {
  EtherAmount weiAmount = EtherAmount.inWei(input);
  double ethAmount = weiAmount.getValueInUnit(EtherUnit.ether);
  return double.parse(ethAmount.toStringAsFixed(6));
}
