import 'package:ax_dapp/pages/athlete/models/AthletePageEvent.dart';
import 'package:ax_dapp/pages/athlete/models/AthletePageState.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:ax_dapp/util/chart/extensions/graphData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:intl/intl.dart';

class AthletePageBloc extends Bloc<AthletePageEvent, AthletePageState> {
  final MLBRepo repo;

  AthletePageBloc({required this.repo}) : super(AthletePageState.initial()) {
    on<OnPageRefresh>(_mapPageRefreshEventToState);
    on<OnGraphRefresh>(_mapGraphRefreshEventToState);
  }

  void _mapPageRefreshEventToState(
      OnPageRefresh event, Emitter<AthletePageState> emit) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime todaysDate = DateTime.now();
    DateTime yesterdaysDate = DateTime(todaysDate.year, todaysDate.month, todaysDate.day-1);
    final String todaysDateString = formatter.format(todaysDate);         
    final String yesterdaysDateString = formatter.format(yesterdaysDate);
    try {
      print("load page stats");
      final int playerId = event.playerId;
      emit(state.copyWith(status: BlocStatus.loading));
      final MLBAthleteStats stats = await repo.getPlayerStatsHistory(playerId, "2022-02-02", "2022-06-21");
      print("fetched MLBAthlete data");
      final List<GraphData> graphStats = stats.statHistory
          .map((stat) => GraphData(
              DateFormat("yyy-MM-dd HH:mm:ss").parse(stat.timeStamp), stat.price * 1000))
          .toList();
      emit(state.copyWith(stats: graphStats, status: BlocStatus.success));
    } catch (e) {
      print("[Console] AthletePage -> Failed to fetch player stats: $e");
      emit(state.copyWith(status: BlocStatus.error));
    }
  }



  void _mapGraphRefreshEventToState(
      OnGraphRefresh event, Emitter<AthletePageState> emit) {}
}
