/// Represents supported & available markets

// ignore_for_file: constant_identifier_names

enum SupportedMarkets {
  /// Mix of all supported markets
  All,

  /// Athlete Performance Markets
  Prediction,

  /// Bitcoin, Ethereum, Thales, SX for example
  Crypto,

  /// SportX, Thales, Polymarket and potentially more
  Sports,

  /// Our Athlete Performance Markets
  Athlete,

  /// Foreign Exchange currency markets
  Forex
}

extension SupportedMarketsX on SupportedMarkets {
  /// Converts the [SupportedMarkets] to a [String]. Removes the enum type.
  String convertToSportString() => toString().split('.').last;
}
