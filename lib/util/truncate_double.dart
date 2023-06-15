import 'dart:math';

/// [truncateToDecimalPlaces] will truncate the [value] and not round it
/// This is to circumnavigate [double.toStringAsFixed] because this will round the decimal place
double truncateToDecimalPlaces({
  required double value,
  required int fractionalDigits,
}) {
  return (value * pow(10, fractionalDigits)).truncate() /
      pow(10, fractionalDigits);
}
