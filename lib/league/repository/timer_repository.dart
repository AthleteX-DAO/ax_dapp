import 'dart:async';

import 'package:league_repository/league_repository.dart';
import 'package:shared/shared.dart';

class TimerRepository {
  late Timer _timer;
  final _remainingTimeController = BehaviorSubject<DurationStatus>();

  ValueStream<DurationStatus> get _remainingTime =>
      _remainingTimeController.stream;

  Stream<DurationStatus> get remainingTime => _remainingTime;

  void timer(String start, String end) {
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final todaysDate = DateTime.now();
        if (todaysDate.isBefore(startDate)) {
          final remainingTime = startDate.difference(todaysDate);
          if (remainingTime.isNegative) {
            cancel();
          } else {
            _remainingTimeController.add(
              DurationStatus(
                days: remainingTime.inDays,
                hours: remainingTime.inHours.remainder(24),
                minutes: remainingTime.inMinutes.remainder(60),
                seconds: remainingTime.inSeconds.remainder(60),
                timerStatus: TimerStatus.pending,
              ),
            );
          }
        } else {
          if (todaysDate.isAfter(startDate)) {
            final remainingTime = endDate.difference(todaysDate);
            if (remainingTime.isNegative) {
              cancel();
            } else {
              _remainingTimeController.add(
                DurationStatus(
                  days: remainingTime.inDays,
                  hours: remainingTime.inHours.remainder(24),
                  minutes: remainingTime.inMinutes.remainder(60),
                  seconds: remainingTime.inSeconds.remainder(60),
                  timerStatus: TimerStatus.started,
                ),
              );
            }
          }
        }
      },
    );
  }

  void cancel() {
    _remainingTimeController.add(
      const DurationStatus(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        timerStatus: TimerStatus.ended,
      ),
    );
    _timer.cancel();
  }
}
