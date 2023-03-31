import 'dart:async';

import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';

part 'league_game_event.dart';
part 'league_game_state.dart';

class LeagueGameBloc extends Bloc<LeagueGameEvent, LeagueGameState> {
  LeagueGameBloc({
    required LeagueRepository leagueRepository,
    required this.rosters,
    required this.repo,
    required StreamAppDataChangesUseCase streamAppDataChanges,
  })  : _leagueRepository = leagueRepository,
        _streamAppDataChanges = streamAppDataChanges,
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
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);

    add(const WatchAppDataChangesStarted());
    add(FetchScoutInfoRequested());
  }

  final LeagueRepository _leagueRepository;
  final Map<String, Map<String, double>> rosters;
  final GetScoutAthletesDataUseCase repo;
  final StreamAppDataChangesUseCase _streamAppDataChanges;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<LeagueGameState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        if (appData.chain.chainId != state.selectedChain.chainId) {
          emit(
            state.copyWith(
              status: BlocStatus.loading,
              selectedChain: appData.chain,
            ),
          );
        }
      },
    );
  }

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
    emit(state.copyWith(status: BlocStatus.loading));
    final rosters = event.rosters;
    final athletes = event.athletes;
    final userTeams = <UserTeam>[];
    rosters.forEach((address, roster) {
      final teamPerformance = checkPrice(roster, athletes);
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
        status: BlocStatus.success,
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

  double checkPrice(
    Map<String, double> roster,
    List<AthleteScoutModel> athletes,
  ) {
    var percentChange = 0.0;
    var teamPerformance = 0.0;
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
        teamPerformance = percentChangeList.reduce((a, b) => a + b);
      }
    });
    return double.parse(teamPerformance.toStringAsFixed(2));
  }

  Future<void> _onFetchScoutInfoRequested(
    FetchScoutInfoRequested event,
    Emitter<LeagueGameState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    var supportedSport = SupportedSport.MLB;
    switch (state.selectedChain) {
      case EthereumChain.goerliTestNet:
      case EthereumChain.polygonMainnet:
      case EthereumChain.unsupported:
        supportedSport = SupportedSport.MLB;
        break;
      case EthereumChain.sxMainnet:
      case EthereumChain.sxTestnet:
        supportedSport = SupportedSport.NFL;
        break;
      // ignore: no_default_cases
      default: // unsupported
        supportedSport = SupportedSport.MLB;
        break;
    }

    final response = await repo.fetchSupportedAthletes(supportedSport);

    filterOutUnsupportedSportsByChain(response);

    add(CalculateAppreciationEvent(rosters: rosters, athletes: response));
  }

  void filterOutUnsupportedSportsByChain(List<AthleteScoutModel> filteredList) {
    if (state.selectedChain == EthereumChain.sxMainnet ||
        state.selectedChain == EthereumChain.sxTestnet) {
      filteredList
          .removeWhere((element) => element.sport == SupportedSport.MLB);
    } else {
      filteredList
          .removeWhere((element) => element.sport == SupportedSport.NFL);
    }
  }
}
