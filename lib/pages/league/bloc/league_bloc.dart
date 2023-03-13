import 'dart:async';

import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:ax_dapp/pages/league/repository/league_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  LeagueBloc({required LeagueRepository leagueRepository})
      : _leagueRepository = leagueRepository,
        super(const LeagueState()) {
    on<CreateLeague>(_onCreateLeague);
    on<FetchLeagues>(_onFetchLeagues);
    on<DeleteLeague>(_onDeleteLeague);
    on<UpdateLeague>(_onUpdateLeague);
    on<UpdateRoster>(_onUpdateRoster);
    on<EnrollUser>(_onEnrollUser);
    on<RemoveUser>(_onRemoveUser);

    add(FetchLeagues());
  }

  final LeagueRepository _leagueRepository;

  Future<void> _onCreateLeague(
    CreateLeague event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final league = event.league;
      await _leagueRepository.createLeague(league: league);
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onFetchLeagues(
    FetchLeagues event,
    Emitter<LeagueState> emit,
  ) async {}

  Future<void> _onDeleteLeague(
    DeleteLeague event,
    Emitter<LeagueState> emit,
  ) async {}

  Future<void> _onUpdateLeague(
    UpdateLeague event,
    Emitter<LeagueState> emit,
  ) async {}

  Future<void> _onUpdateRoster(
    UpdateRoster event,
    Emitter<LeagueState> emit,
  ) async {}

  Future<void> _onEnrollUser(
    EnrollUser event,
    Emitter<LeagueState> emit,
  ) async {}

  Future<void> _onRemoveUser(
    RemoveUser event,
    Emitter<LeagueState> emit,
  ) async {}
}
