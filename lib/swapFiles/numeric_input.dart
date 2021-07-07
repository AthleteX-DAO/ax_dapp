import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// An input field for numeric inputs only that displays a label on its border.
/// It performs validation on the input entered before delegating to the
/// provided handler.
class NumericInput extends StatefulWidget {
  final String label;
  final ValueChanged<double> onChangeHandler;

  const NumericInput({
    Key key,
    @required this.label,
    @required this.onChangeHandler
  }) : assert(label != null),
       assert(onChangeHandler != null),
       super(key: key);

  @override
  State<StatefulWidget> createState() => _NumericInputState();
}

class _NumericInputState extends State<NumericInput> {
  bool _hasInvalidInput = false;

  void _handleOnChange(String value) {
    setState(() {
      if (value.isEmpty) {
        this._hasInvalidInput = false;
        return;
      }

      try {
        final double valueAsDouble = double.parse(value);
        this._hasInvalidInput = false;
        widget.onChangeHandler(valueAsDouble);
      } on Exception catch (e) {
        print('Caught exception while converting value to double: $e');
        this._hasInvalidInput = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.display1,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.display1,
        errorText: this._hasInvalidInput ? 'Invalid number' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
      keyboardType: TextInputType.number,
      onChanged: this._handleOnChange,
    );
  }
}