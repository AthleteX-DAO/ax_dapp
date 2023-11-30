/// Represents supported & available markets

enum SupportedMarkets {
  /// Mix of all supported markets
  all,

  /// Athlete Performance Markets
  prediction,

  /// Bitcoin, Ethereum, Thales, SX for example
  crypto,

  /// SportX, Thales, Polymarket and potentially more
  sports,

  /// Our Athlete Performance Markets
  athlete,

  /// Foreign Exchange currency markets
  forex
}

extension SupportedMarketsX on SupportedMarkets {
  /// Converts the [SupportedMarkets] to a [String]. Removes the enum type.
  String convertToSportString() => toString().split('.').last;
}
