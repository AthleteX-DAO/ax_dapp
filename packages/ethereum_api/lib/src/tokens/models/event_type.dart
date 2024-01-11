part of 'token.dart';

enum EventType {
  /// Represents no [Event] type
  none,

  /// Type of [Event.yes]
  yes,

  /// Type of [Event.no]
  no,
}

/// [EventType] extensions.
extension EventTypeX on EventType {
  /// Returns `true` if the [EventType] is long.
  bool get isYes => this == EventType.yes;

  /// Returns `true` if the [EventType] is short.
  bool get isNo => this == EventType.no;

  /// Returns the correspondent apt url for this [EventType].
  String get url => isYes
      ? 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_noninverted.png'
      : 'https://raw.githubusercontent.com/SportsToken/ax_dapp/develop/assets/images/apt_inverted.png';
}
