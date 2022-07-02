import 'package:ax_dapp/pages/athlete/models/AthletePageEvent.dart';
import 'package:ax_dapp/pages/athlete/models/AthletePageState.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/chart/extensions/graphData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month-1, now.day);
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      var until = formattedDate;
      var from = formattedStartDate;
      final MLBAthleteStats stats = await repo.getPlayerStatsHistory(
          playerId, from, until);
      print("fetched MLBAthlete data");
      final List<GraphData> graphStats = stats.statHistory
          .map((stat) => GraphData(
              DateFormat("yyy-MM-dd").parse(stat.timeStamp),
              stat.price * 1000))
          .toList();    
      Set<DateTime> seenDates = {};
      final List<GraphData> distinctPoints = graphStats.where((element) => seenDates.add(element.date)).toList();
      emit(state.copyWith(stats: distinctPoints, status: BlocStatus.success));
    } catch (e) {
      print("[Console] AthletePage -> Failed to fetch player stats: $e");
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapGraphRefreshEventToState(
      OnGraphRefresh event, Emitter<AthletePageState> emit) {}
}
