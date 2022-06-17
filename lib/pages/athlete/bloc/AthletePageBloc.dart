import 'package:ax_dapp/pages/athlete/models/AthletePageEvent.dart';
import 'package:ax_dapp/pages/athlete/models/AthletePageState.dart';
import 'package:ax_dapp/repositories/SportsRepo.dart';
import 'package:ax_dapp/service/athleteModels/mlb/MLBPAthleteStats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ax_dapp/util/BlocStatus.dart';

class AthletePageBloc extends Bloc<AthletePageEvent, AthletePageState> {
  final SportsRepo repo;

  AthletePageBloc({required this.repo}) : super(const AthletePageState()) {
    on<OnPageRefresh>(_mapPageRefreshEventToState);
  }

  void _mapPageRefreshEventToState(
      OnPageRefresh event, Emitter<AthletePageState> emit) async {
    try {
      print("load page stats");
      final int playerId = event.playerId;
      emit(state.copyWith(status: BlocStatus.loading));
      final MLBAthleteStats stats = await repo.getPlayerStatsHistory(playerId);
      emit(state.copyWith(stats: stats, status: BlocStatus.success));
    } catch (e) {
      print("[Console] AthletePage -> Failed to fetch player stats: $e");
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
