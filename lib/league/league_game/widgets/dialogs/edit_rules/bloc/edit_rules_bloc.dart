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
    final startDate = DateTime.parse(state.dateStart);
    final endDate = DateTime.parse(state.dateEnd);
    try {
      if (state.name.isEmpty || state.sports.isEmpty) {
        emit(
          state.copyWith(
            errorMessage: 'One or More Fields Are Empty!',
            status: BlocStatus.error,
          ),
        );
      } else if (startDate.isAfter(endDate) || startDate == endDate) {
        emit(
          state.copyWith(
            errorMessage: 'Invalid Dates!',
            status: BlocStatus.error,
          ),
        );
      } else if (state.maxTeams <= 1) {
        emit(
          state.copyWith(
            errorMessage: 'Need to Have More Than One Participant!',
            status: BlocStatus.error,
          ),
        );
      } else {
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
        await _leagueRepository.updateLeague(
          leagueID: state.league.leagueID,
          league: updatedLeague,
        );
        emit(state.copyWith(status: BlocStatus.success));
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  FutureOr<void> _onUpdateName(
    UpdateName event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        name: event.name,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateStartDate(
    UpdateStartDate event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        dateStart: event.startDate,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateEndDate(
    UpdateEndDate event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        dateEnd: event.endDate,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateTeamSize(
    UpdateTeamSize event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        teamSize: event.teamSize,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateParticipants(
    UpdateParticipants event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        maxTeams: event.participants,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateEntryFee(
    UpdateEntryFee event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        entryFee: event.entryFee,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdatePrivateToggle(
    UpdatePrivateToggle event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        isPrivate: event.privateToggleValue,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateLockToggle(
    UpdateLockToggle event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        isLocked: event.lockedToggleValue,
        status: BlocStatus.success,
      ),
    );
  }

  FutureOr<void> _onUpdateSports(
    UpdateSports event,
    Emitter<EditRulesState> emit,
  ) async {
    emit(
      state.copyWith(
        sports: event.selectedSports,
        status: BlocStatus.success,
      ),
    );
  }
}
