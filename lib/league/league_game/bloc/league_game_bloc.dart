import 'dart:async';

import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'league_game_event.dart';
part 'league_game_state.dart';

class LeagueGameBloc extends Bloc<LeagueGameEvent, LeagueGameState> {
  LeagueGameBloc({
    required LeagueRepository leagueRepository,
    required this.athleteList,
  })  : _leagueRepository = leagueRepository,
        super(LeagueGameState(athletes: athleteList)) {
    on<InviteEvent>(_onInviteEvent);
    on<EditTeamsEvent>(_onEditTeams);
    on<ClaimPrizeEvent>(_onClaimPrize);
    on<TimerEvent>(_onTimerEvent);
    on<CalculateAppreciationEvent>(_onCalculateAppreciationEvent);
    on<JoinLeagueEvent>(_onJoinLeagueEvent);
    on<LeaveLeagueEvent>(_onLeaveTeamEvent);
  }

  final LeagueRepository _leagueRepository;
  final List<AthleteScoutModel> athleteList;

  Future<void> _onInviteEvent(
    InviteEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onEditTeams(
    EditTeamsEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onClaimPrize(
    ClaimPrizeEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onTimerEvent(
    TimerEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onCalculateAppreciationEvent(
    CalculateAppreciationEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onJoinLeagueEvent(
    JoinLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onLeaveTeamEvent(
    LeaveLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}
}
