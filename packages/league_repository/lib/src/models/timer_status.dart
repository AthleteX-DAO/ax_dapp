/// Represents the status of a timer.
enum TimerStatus {
  /// A timer that has started.
  started,

  /// A timer that has yet to start.
  pending,

  /// A timer that has ended.
  ended,

  /// An initial timer.
  initial,
}

/// [TimerStatus] extensions.
extension TimerStatusX on TimerStatus {
  /// Returns `true` if the timer has started.
  bool get hasStarted => this == TimerStatus.started;

  /// Returns `true` if the timer has ended.
  bool get hasEnded => this == TimerStatus.ended;

  /// Returns `true` if the timer has yet to start.
  bool get isPending => this == TimerStatus.pending;
}
