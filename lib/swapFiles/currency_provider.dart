import 'dart:async';

import 'package:ae_dapp/swapFiles/unit.dart';

/// Provides units and conversion rates for the currency [Category]
abstract class CurrencyProvider {
  /// Retrieves all units and conversion rates
  Future<List<Unit>> getUnits();

  /// Converts the given value from one [Unit] to another
  Future<double> convert(Unit from, Unit to, double value);
}