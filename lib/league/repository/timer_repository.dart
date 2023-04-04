import 'dart:async';

import 'package:ax_dapp/league/models/duration_status.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
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
    if (DateTime.now().isBefore(startDate)) {
      final difference = endDate.difference(startDate);
      _remainingTimeController.add(
        DurationStatus(
          days: difference.inDays,
          hours: difference.inHours.remainder(24),
          minutes: difference.inMinutes.remainder(60),
          seconds: difference.inSeconds.remainder(60),
          timerStatus: TimerStatus.pending,
        ),
      );
    } else {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          final remainingTime = endDate.difference(DateTime.now());
          if (DateTime.now().isAfter(startDate)) {
            if (remainingTime.isNegative) {
              _remainingTimeController.add(
                const DurationStatus(
                  days: 0,
                  hours: 0,
                  minutes: 0,
                  seconds: 0,
                  timerStatus: TimerStatus.ended,
                ),
              );
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
        },
      );
    }
  }

  void cancel() {
    _remainingTimeController.add(
      const DurationStatus(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        timerStatus: TimerStatus.closed,
      ),
    );
    _timer.cancel();
  }
}
