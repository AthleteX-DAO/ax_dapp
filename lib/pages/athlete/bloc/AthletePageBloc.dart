import 'package:ax_dapp/pages/athlete/models/AthletePageEvent.dart';
import 'package:ax_dapp/pages/athlete/models/AthletePageState.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/BlocStatus.dart';

class AthletePageBloc extends Bloc<AthletePageEvent, AthletePageState> {
  final MLBRepo repo;

  AthletePageBloc({required this.repo}) : super(AthletePageState.initial()) {
    on<OnPageRefresh>(_mapPageRefreshEventToState);
    on<OnGraphRefresh>(_mapGraphRefreshEventToState);
  }

  void _mapPageRefreshEventToState(
      OnPageRefresh event, Emitter<AthletePageState> emit) async {
    try {
      print("load page stats");
      final int playerId = event.playerId;
      emit(state.copyWith(status: BlocStatus.loading));
      final MLBAthleteStats stats = await repo.getPlayerStatsHistory(playerId, "2022-02-02", "2022-05-10");
      print("fetched MLBAthlete data");
      final List<FlSpot> chartStats = stats.statHistory
          .map((stat) => FlSpot(
              DateTime.parse(stat.timeStamp).day as double, stat.price * 1000))
          .toList();
      print(chartStats);
      emit(state.copyWith(stats: chartStats, status: BlocStatus.success));
    } catch (e) {
      print("[Console] AthletePage -> Failed to fetch player stats: $e");
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapGraphRefreshEventToState(
      OnGraphRefresh event, Emitter<AthletePageState> emit) {}
}
