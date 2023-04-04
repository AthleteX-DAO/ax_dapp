import 'package:equatable/equatable.dart';

/// {@template timerDuration}
/// Holds timer related data.
/// {@endtemplate}
class TimerDuration extends Equatable {
  /// {@macro timerDuration}
  const TimerDuration({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  /// Time in days.
  final int days;

  /// Time in hours.
  final int hours;

  /// Time in minutes.
  final int minutes;

  /// Time in seconds.
  final int seconds;

  @override
  List<Object?> get props => [
        days,
        hours,
        minutes,
        seconds,
      ];
}
