import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'athlete_page_event.dart';
part 'athlete_page_state.dart';

class AthletePageBloc extends Bloc<AthletePageEvent, AthletePageState> {
  AthletePageBloc({required this.repo}) : super(AthletePageState.initial()) {
    on<OnPageRefresh>(_mapPageRefreshEventToState);
    on<OnGraphRefresh>(_mapGraphRefreshEventToState);
  }

  final MLBRepo repo;

  Future<void> _mapPageRefreshEventToState(
    OnPageRefresh event,
    Emitter<AthletePageState> emit,
  ) async {
    try {
      final playerId = event.playerId;
      emit(state.copyWith(status: BlocStatus.loading));
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month - 1, now.day);
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      final until = formattedDate;
      final from = formattedStartDate;
      final stats = await repo.getPlayerStatsHistory(
        playerId,
        from,
        until,
      );
      final graphStats = stats.statHistory
          .map(
            (stat) => GraphData(
              DateFormat('yyy-MM-dd').parse(stat.timeStamp),
              stat.price * 1000,
            ),
          )
          .toList();
      final seenDates = <DateTime>{};
      final distinctPoints =
          graphStats.where((element) => seenDates.add(element.date)).toList();
      emit(state.copyWith(stats: distinctPoints, status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapGraphRefreshEventToState(
    OnGraphRefresh event,
    Emitter<AthletePageState> emit,
  ) {}
}
