import 'dart:async';

import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'edit_rules_event.dart';
part 'edit_rules_state.dart';

class EditRulesBloc extends Bloc<EditRulesEvent, EditRulesState> {
  EditRulesBloc({
    required this.league,
    required LeagueRepository leagueRepository,
  })  : _leagueRepository = leagueRepository,
        super(
          EditRulesState(
            league: league,
            leagueID: league.leagueID,
            name: league.name,
            dateStart: league.dateStart,
            dateEnd: league.dateEnd,
            teamSize: league.teamSize,
            maxTeams: league.maxTeams,
            entryFee: league.entryFee,
            isPrivate: league.isPrivate,
            isLocked: league.isLocked,
            sports: league.sports,
          ),
        ) {
    on<UpdateLeague>(_onUpdateLeague);
    on<UpdateName>(_onUpdateName);
    on<UpdateStartDate>(_onUpdateStartDate);
    on<UpdateEndDate>(_onUpdateEndDate);
    on<UpdateTeamSize>(_onUpdateTeamSize);
    on<UpdateParticipants>(_onUpdateParticipants);
    on<UpdateEntryFee>(_onUpdateEntryFee);
    on<UpdatePrivateToggle>(_onUpdatePrivateToggle);
    on<UpdateLockToggle>(_onUpdateLockToggle);
    on<UpdateSports>(_onUpdateSports);
  }

  final League league;
  final LeagueRepository _leagueRepository;

  FutureOr<void> _onUpdateLeague(
    UpdateLeague event,
    Emitter<EditRulesState> emit,
  ) async {
    try {
      final updatedLeague = state.league.copyWith(
        name: state.name,
        dateStart: state.dateStart,
        dateEnd: state.dateEnd,
        teamSize: state.teamSize,
        maxTeams: state.maxTeams,
        entryFee: state.entryFee,
        isLocked: state.isLocked,
        isPrivate: state.isPrivate,
        sports: state.sports,
      );
      print(updatedLeague);
      await _leagueRepository.updateLeague(
        leagueID: state.league.leagueID,
        league: updatedLeague,
      );
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  FutureOr<void> _onUpdateName(
    UpdateName event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _onUpdateStartDate(
    UpdateStartDate event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(dateStart: event.startDate));
  }

  FutureOr<void> _onUpdateEndDate(
    UpdateEndDate event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(dateEnd: event.endDate));
  }

  FutureOr<void> _onUpdateTeamSize(
    UpdateTeamSize event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(teamSize: event.teamSize));
  }

  FutureOr<void> _onUpdateParticipants(
    UpdateParticipants event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(maxTeams: event.participants));
  }

  FutureOr<void> _onUpdateEntryFee(
    UpdateEntryFee event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(entryFee: event.entryFee));
  }

  FutureOr<void> _onUpdatePrivateToggle(
    UpdatePrivateToggle event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(isPrivate: event.privateToggleValue));
  }

  FutureOr<void> _onUpdateLockToggle(
    UpdateLockToggle event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(isLocked: event.lockedToggleValue));
  }

  FutureOr<void> _onUpdateSports(
    UpdateSports event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(state.copyWith(sports: event.selectedSports));
  }
}
