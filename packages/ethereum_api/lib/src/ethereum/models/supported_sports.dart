/// Represents supported sports.
// ignore_for_file: constant_identifier_names

enum SupportedSport {
  /// All sports.
  all,

  /// Represents National Football League.
  NFL,

  /// Represents Major League Baseball.
  MLB,

  /// Represents National Basketball Association.
  NBA,
}

/// [SupportedSport] extensions.
extension SupportedSportX on SupportedSport {
  /// Converts the [SupportedSport] to a [String]. Removes the enum type.
  String convertToSportString() => toString().split('.').last;
}
