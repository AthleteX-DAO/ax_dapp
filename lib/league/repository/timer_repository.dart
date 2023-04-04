import 'dart:async';

import 'package:ax_dapp/league/models/timer_duration.dart';
import 'package:shared/shared.dart';

class TimerRepository {
  late Timer _timer;
  final _remainingTimeController = BehaviorSubject<TimerDuration>();

  ValueStream<TimerDuration> get _remainingTime =>
      _remainingTimeController.stream;

  Stream<TimerDuration> get remainingTime => _remainingTime;

  void timer(String start, String end) {
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DateTime.now().isAfter(startDate)) {
        final remainingTime = endDate.difference(DateTime.now());
        if (remainingTime.isNegative) {
          _remainingTimeController.add(
            const TimerDuration(
              days: 0,
              hours: 0,
              minutes: 0,
              seconds: 0,
            ),
          );
          cancel();
        } else {
          final remainingDays = remainingTime.inDays;
          final remainingHours = remainingTime.inHours.remainder(24);
          final remainingMinutes = remainingTime.inMinutes.remainder(60);
          final remainingSeconds = remainingTime.inSeconds.remainder(60);
          _remainingTimeController.add(
            TimerDuration(
              days: remainingDays,
              hours: remainingHours,
              minutes: remainingMinutes,
              seconds: remainingSeconds,
            ),
          );
        }
      }
    });
  }

  void cancel() {
    _remainingTimeController.add(
      const TimerDuration(
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
      ),
    );
    _timer.cancel();
  }
}
