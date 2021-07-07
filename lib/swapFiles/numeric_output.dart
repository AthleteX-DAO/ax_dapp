import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// A text field for numeric outputs only that displays a label on its border.
class NumericOutput extends StatelessWidget {
  final String label;
  final double value;

  const NumericOutput({
    @required this.label,
    this.value
  }) : assert(label != null);

  /// Clean up value; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  /// Provided by Udacity
  String _formatValue() {
    if (null == this.value) {
      return "";
    }

    String formattedValue = this.value.toStringAsPrecision(7);

    // Remove all trailing zeros
    if (formattedValue.contains('.') && formattedValue.endsWith('0')) {
      int i = formattedValue.length - 1;

      while (formattedValue[i] == '0') {
        i -= 1;
      }

      formattedValue = formattedValue.substring(0, i + 1);
    }

    // Remove the decimal point if the value is an integer
    if (formattedValue.endsWith('.')) {
      return formattedValue.substring(0, formattedValue.length - 1);
    }

    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      child: Text(
        this._formatValue(),
        key: Key('driver-numeric-output'),
        style: Theme.of(context).textTheme.display1,
      ),
      decoration: InputDecoration(
        labelText: this.label,
        labelStyle: Theme.of(context).textTheme.display1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
    );
  }
}