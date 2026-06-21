/// Represents the three exchange verticals in the AthleteX ecosystem.
enum ExchangeTab { predictions, spot, perps }

/// Display-friendly names for [ExchangeTab].
extension ExchangeTabX on ExchangeTab {
  String get displayName {
    switch (this) {
      case ExchangeTab.predictions:
        return 'Predictions';
      case ExchangeTab.spot:
        return 'Spot';
      case ExchangeTab.perps:
        return 'Perps';
    }
  }
}
