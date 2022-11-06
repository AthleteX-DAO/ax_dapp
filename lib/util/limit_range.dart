import 'package:flutter/services.dart';

class LimitRange extends TextInputFormatter {
  /// Creates a formatter that specifies a number range
  /// That the user is allowed to enter.
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(minRange < maxRange, 'Minimum range must always be strictly lesser than the Maximum range');

  /// Determines the [minRange] that the user is allowed to start from
  final int minRange;
  /// Determines the [maxRange] that the user is not allowed to exceed
  final int maxRange;

  /// defines a [TextEditingValue] to check if the input is 
  /// between the [minRange] and the [maxRange].
  /// 
  /// checks if the value is less than the [minRange]
  /// if it is, set the [TextEditingValue] to the [minRange].
  /// 
  /// checks if the value is greater than the [maxRange]
  /// if it is, set the [TextEditingValue] to the [maxRange].
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final value = int.parse(newValue.text);
    if (value < minRange) {
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}
