/// Represents the status of a timer.
enum TimerStatus {
  /// A timer that has started.
  started,

  /// A timer that has yet to start.
  pending,

  /// A timer that has ended.
  ended,

  /// A timer that is closed.
  closed,

  /// An initial timer.
  initial,
}

/// [TimerStatus] extensions
extension TimerStatusX on TimerStatus {
  bool get isStarted => this == TimerStatus.started;

  bool get hasEnded => this == TimerStatus.ended;
}
