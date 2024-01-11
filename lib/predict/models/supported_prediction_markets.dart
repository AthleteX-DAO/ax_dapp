/// Represents supported & available prediction markets

enum SupportedPredictionMarkets {
  // Mix of all Supported Markets
  all,

  /// College Athletes
  college,

  /// Basketball Athletes
  basketball,

  /// Football Athletes
  football,

  /// Hockey Athletes
  hockey,

  /// Baseball Athletes
  baseball,

  /// Soccer Athletes
  soccer,

  /// Voted markets from snapshot
  voted,

  /// Exotic Athlete Markets
  exotic
}

extension SupportedPredictionMarketsX on SupportedPredictionMarkets {
  /// Converts the [SupportedPredictionMarkets] to a [String]. Removes the enum type.
  String convertToSportString() => toString().split('.').last;
}
