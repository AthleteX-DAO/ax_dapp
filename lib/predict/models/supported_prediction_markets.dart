/// Represents supported & available prediction markets

enum SupportedPredictionMarkets {

  // Mix of all Supported Markets
  all,

  /// College Athletes
  College,

  /// Basketball Athletes
  Basketball,

  /// Football Athletes
  Football,

  /// Hockey Athletes
  Hockey,

  /// Baseball Athletes
  Baseball,

  /// Soccer Athletes
  Soccer,

  /// Exotic Athlete Markets
  Exotic
}

extension SupportedPredictionMarketsX on SupportedPredictionMarkets {
  /// Converts the [SupportedPredictionMarkets] to a [String]. Removes the enum type.
  String convertToSportString() => toString().split('.').last;
}
