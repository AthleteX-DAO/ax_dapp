import 'package:ax_dapp/pages/scout/models/AthleteScoutModel.dart';
import 'package:ax_dapp/pages/scout/models/ScoutPageState.dart';
import 'package:ax_dapp/pages/scout/usecases/GetScoutAthletesDataUseCase.dart';
import 'package:ax_dapp/util/BlocStatus.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ScoutPageEvent.dart';

class ScoutPageBloc extends Bloc<ScoutPageEvent, ScoutPageState> {
  final GetScoutAthletesDataUseCase repo;

  ScoutPageBloc({required this.repo}) : super(ScoutPageState.initial()) {
    on<OnPageRefresh>(_mapRefreshEventToState);
    on<SelectSport>(_mapSelectSportToState);
    on<OnAthleteSearch>(_mapSearchAthleteEventToState);
  }

  void _mapRefreshEventToState(
      OnPageRefresh event, Emitter<ScoutPageState> emit) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final response = await repo.fetchSupportedAthletes(SupportedSport.ALL);
      if (response.isNotEmpty) {
        emit(state.copyWith(
          athletes: response,
          filteredAthletes: response,
          selectedSport: SupportedSport.ALL,
          status: BlocStatus.success));
      } else {
        print("[Console] Scout Page -> All Athletes not supported");
        emit(state.copyWith(status: BlocStatus.no_data, filteredAthletes: [], athletes: [], selectedSport: null));
      }    
    } catch (e) {
      print("[Console] Scout Page -> Failed to load athlete list: $e");
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _mapSelectSportToState(
      SelectSport event, Emitter<ScoutPageState> emit) async {
        try {
          emit(state.copyWith(status: BlocStatus.loading));
          final List<AthleteScoutModel> filteredList = state.athletes.where((athlete) => event.selectedSport.name == athlete.sport.name).toList();
          if (filteredList.isNotEmpty) {
            emit(state.copyWith(status: BlocStatus.success, filteredAthletes: filteredList, selectedSport: event.selectedSport));
          } else {
            print("[Console] Scout Page -> Selected Sport not supported");
            emit(state.copyWith(status: BlocStatus.no_data, filteredAthletes: [], selectedSport: event.selectedSport));
          } 
        } catch (e) {
          print("[Console] Scout Page -> Failed to load athlete list: $e");
          emit(state.copyWith(status: BlocStatus.error));
        }
  }

  void _mapSearchAthleteEventToState(
      OnAthleteSearch event, Emitter<ScoutPageState> emit) {
    //TODO update list with search result
  }
}
