import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/ScoutPageState.dart';
import 'package:ax_dapp/repositories/MlbRepo.dart';
import 'package:ax_dapp/service/SupportedAthletes/SupportedMLBAthletes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ScoutPageEvent.dart';

class ScoutPageBloc extends Bloc<ScoutPageEvent, ScoutPageState> {
  final MLBRepo mlbRepo;
  final List<AthleteScoutModel> mlbAthletes = [];

  ScoutPageBloc({required this.mlbRepo}) : super(const ScoutPageState()) {
    on<OnPageRefresh>(_mapRefreshEventToState);
    on<SelectSport>(_mapSelectSportToState);
    on<OnAthleteSearch>(_mapSearchAthleteEventToState);
  }

  void _mapRefreshEventToState(
      OnPageRefresh event, Emitter<ScoutPageState> emit) async {
    try {
      emit(state.copy(status: Status.loading));
      final response = await mlbRepo
          .getPlayersById(SupportedMLBAthletes().getSupportedAthletesList());

      mlbAthletes.addAll(response
          .map((athlete) => AthleteScoutModel(athlete.id, athlete.name,
              athlete.position, athlete.team, athlete.price, Sport.MLB))
          .toList());

      emit(state.copy(
          athletes: mlbAthletes,
          selectedSport: SelectedSport.ALL,
          status: Status.success));
    } catch (e) {
      print("[Console] Scout Page -> Failed to load athlete list: $e");
      emit(state.copy(status: Status.error));
    }
  }

  void _mapSelectSportToState(
      SelectSport event, Emitter<ScoutPageState> emit) async {
    emit(state.copy(
        athletes: state.athletes
            .where((athlete) => event.selectedSport.name == athlete.sport.name)
            .toList(),
        selectedSport: event.selectedSport));
  }

  void _mapSearchAthleteEventToState(
      OnAthleteSearch event, Emitter<ScoutPageState> emit) {
    //TODO update list with search result
  }
}
