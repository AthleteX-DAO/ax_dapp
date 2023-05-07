
import 'package:equatable/equatable.dart';
import 'package:league_repository/src/models/models.dart';

/// {@template duration_status}
/// Holds data related to the duration of a league.
/// {@endtemplate}
class DurationStatus extends Equatable {
  /// {@macro duration_status}
  const DurationStatus({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.timerStatus,
  });

  /// Time in days.
  final int days;

  /// Time in hours.
  final int hours;

  /// Time in minutes.
  final int minutes;

  /// Time in seconds.
  final int seconds;

  /// Status of the timer.
  final TimerStatus timerStatus;

  @override
  List<Object?> get props => [
        days,
        hours,
        minutes,
        seconds,
        timerStatus,
      ];
}
