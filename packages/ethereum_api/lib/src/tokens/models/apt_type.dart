part of 'token.dart';

/// Represents types of [Apt].
enum AptType {
  /// Represents no [Apt] type.
  none,

  /// Type of [Apt.long].
  long,

  /// Type of [Apt.short].
  short,

  /// Type of [Apt.yes]
  yes,

  /// Type of [Apt.no]
  no,
}

/// [AptType] extensions.
extension AptTypeX on AptType {
  /// Returns `true` if the [AptType] is long.
  bool get isLong => this == AptType.long;

  /// Returns `true` if the [AptType] is short.
  bool get isShort => this == AptType.short;

  bool get isYes => this == AptType.yes;

  bool get isNo => this == AptType.no;

  /// Returns the correspondent apt url for this [AptType].
  String get url => isLong
      ? 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_noninverted.png'
      : 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_inverted.png';
}
