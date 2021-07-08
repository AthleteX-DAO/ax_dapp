// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ae_dapp/swapFiles/unit.dart';
import 'package:ae_dapp/swapFiles/numeric_input.dart';
import 'package:ae_dapp/swapFiles/dropdown.dart';
import 'package:ae_dapp/swapFiles/numeric_output.dart';
import 'package:ae_dapp/swapFiles/error_banner.dart';
import 'package:ae_dapp/swapFiles/category.dart';
import 'package:ae_dapp/swapFiles/currency_provider.dart';

/// Converter screen where users can input amounts to convert.
class ConverterScreen extends StatefulWidget {
  final Category? category; // Need it to take only a single list of Units (don't need Category) OR just need a single CRYPTO CATEGORY
  final CurrencyProvider? currencyProvider;

  /// This [ConverterScreen] requires [Category] to not be null.
  const ConverterScreen({
    @required this.category,
    this.currencyProvider,
  }) : assert(category != null);

  @override
  State<StatefulWidget> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Create a [GlobalKey] to persist changes to the input [TextField] when
  // switching between orientation modes
  // See: https://docs.flutter.io/flutter/widgets/GlobalKey-class.html
  final GlobalKey _inputKey = GlobalKey(debugLabel: 'inputText');

  double? _inputValue;
  double? _outputValue;
  Unit? _to;
  Unit? _from;
  bool? _showError;

  void _setDefaults() {
    // Update the conversions, and trigger the computation of the output value
    setState(() {
      this._from = widget.category!.units![0];
      this._to = widget.category!.units![0];
      this._updateConversion();
      this._showError = false;
    });
  }

  Future<void> _updateConversion() async {
    if (null == this._inputValue) {
      return;
    }

    double? converted;
    bool inErrorState = false;

    // For the Currency [Category] use an external provider for the conversion
    if (widget.category!.name == 'Currency') {
      try {
        converted = await widget.currencyProvider!
            .convert(this._from!, this._to!, this._inputValue!);
      } catch (e) {
        inErrorState = true;
      }
    } else {
      converted =
          this._inputValue! * (this._to!.conversion! / this._from!.conversion!);
    }

    setState(() {
      this._outputValue = converted;
      this._showError = inErrorState;
    });
  }

  void _handleOnInputValueChange(double inputValue) {
    setState(() {
      this._inputValue = inputValue;
      this._updateConversion();
    });
  }

  void _handleOnFromConversionValueChange(Unit from) {
    setState(() {
      this._from = from;
      this._updateConversion();
    });
  }

  void _handleOnToConversionValueChange(Unit to) {
    setState(() {
      this._to = to;
      this._updateConversion();
    });
  }

  Widget _buildVerticallyCenteredGroup(List<Widget> components) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: components,
        )
    );
  }

  Widget _buildInputGroup() {
    return this._buildVerticallyCenteredGroup(
        <Widget>[
          NumericInput(
            key: this._inputKey,
            label: 'Input',
            onChangeHandler: (value) => this._handleOnInputValueChange(value),
          ),
          // Add some padding to create space between components
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Dropdown(
            key: Key('driver-from-dropdown'),
            units: widget.category!.units,
            onChangeHandler: (unit) =>
                this._handleOnFromConversionValueChange(unit),
          ),
        ]
    );
  }

  Widget _buildOutputGroup() {
    return this._buildVerticallyCenteredGroup(
        <Widget>[
          NumericOutput(
            label: 'Output',
            value: this._outputValue,
          ),
          // Add some padding to create space between components
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Dropdown(
            key: Key('driver-to-dropdown'),
            units: widget.category!.units,
            onChangeHandler: (unit) =>
                this._handleOnToConversionValueChange(unit),
          ),
        ]
    );
  }

  @override
  void initState() {
    super.initState();
    this._setDefaults();
  }

  @override
  void didUpdateWidget(ConverterScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update the conversions when a new [Category] is selected
    if (oldWidget.category != widget.category) {
      this._setDefaults();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._showError!) {
      return ErrorBanner();
    }

    final Widget inputGroup = this._buildInputGroup();
    final Widget outputGroup = this._buildOutputGroup();
    final Widget conversionArrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    final Widget converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[inputGroup, conversionArrows, outputGroup],
    );

    final Widget converterGroup = Padding(
        padding: EdgeInsets.all(16.0),
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.portrait) {
              // Use a `SingleChildScrollView` to ensure the converter is
              // viewable on all screens and is scrollable when the screen is
              // too small. It also removes the `RenderFlex` exception while the
              // front panel of the [Backdrop] is being opened and closed
              return SingleChildScrollView(
                child: converter,
              );
            } else {
              // In landscape mode, center the converter with a fixed width
              // so that it does not stretch out completely
              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: 450.0,
                    child: converter,
                  ),
                ),
              );
            }
          },
        )
    );

    return converterGroup;
  }
}