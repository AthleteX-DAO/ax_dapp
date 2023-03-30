import 'dart:async';

import 'package:ax_dapp/league/models/user_team.dart';
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
    required this.rosters,
  })  : _leagueRepository = leagueRepository,
        super(
          LeagueGameState(
            rosters: rosters,
          ),
        ) {
    on<InviteEvent>(_onInviteEvent);
    on<EditTeamsEvent>(_onEditTeams);
    on<ClaimPrizeEvent>(_onClaimPrize);
    on<TimerEvent>(_onTimerEvent);
    on<CalculateAppreciationEvent>(_onCalculateAppreciationEvent);
    on<JoinLeagueEvent>(_onJoinLeagueEvent);
    on<LeaveLeagueEvent>(_onLeaveTeamEvent);
  }

  final LeagueRepository _leagueRepository;
  final Map<String, Map<String, double>> rosters;

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
  ) async {
    final rosters = event.rosters;
    final athletes = event.athletes;
    final userTeams = <UserTeam>[];
    rosters.forEach((address, roster) {
      final individualPerformance = checkPrice(roster, athletes);
      final teamPerformance = individualPerformance.reduce((a, b) => a + b);
      userTeams.add(
        UserTeam(
          address: address,
          roster: roster,
          teamPerformance: teamPerformance,
        ),
      );
    });
    emit(
      state.copyWith(
        userTeams: userTeams,
      ),
    );
  }

  Future<void> _onJoinLeagueEvent(
    JoinLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  Future<void> _onLeaveTeamEvent(
    LeaveLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {}

  List<double> checkPrice(
    Map<String, double> roster,
    List<AthleteScoutModel> athletes,
  ) {
    var percentChange = 0.0;
    final percentChangeList = <double>[];
    roster.forEach((athlete, price) {
      final name =
          roster.keys.firstWhere((element) => roster[element] == price);
      final initialPrice = roster[name];
      final athlete = athletes.firstWhere(
        (athlete) =>
            athlete.name.trim().toLowerCase() == name.trim().toLowerCase(),
        orElse: () => AthleteScoutModel.empty,
      );
      if (athlete.longTokenBookPrice != roster[name]) {
        percentChange =
            ((athlete.longTokenBookPrice! - initialPrice!) / initialPrice) *
                100;
        percentChangeList.add(percentChange);
      }
    });
    return percentChangeList;
  }
}
