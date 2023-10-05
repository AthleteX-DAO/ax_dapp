/// Represents types of [OverUnder] positions.

enum OverUnder {
  /// Represents no [OverUnder]
  none,

  /// Type of [OverUnder.over]
  over,

  /// Type of [OverUnder.under]
  under,
}

extension OverUnderX on OverUnder {
  /// Returns the name of the 'Over' if the [OverUnder] is selected
  bool get Over => this == OverUnder.over;
  String get over => this == OverUnder.over ? 'over' : 'under';

  /// Returns the name of the 'Under' if the [OverUnder] is selected
  bool get under => this == OverUnder.under;
}
