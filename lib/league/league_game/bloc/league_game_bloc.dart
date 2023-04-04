import 'dart:async';

import 'package:ax_dapp/league/models/duration_status.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/calculate_team_performance_usecase.dart';
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
    required this.startDate,
    required this.endDate,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required CalculateTeamPerformanceUseCase calculateTeamPerformanceUseCase,
    required TimerRepository timerRepository,
  })  : _leagueRepository = leagueRepository,
        _streamAppDataChanges = streamAppDataChanges,
        _calculateTeamPerformanceUseCase = calculateTeamPerformanceUseCase,
        _tickerRepository = timerRepository,
        super(
          LeagueGameState(
            startDate: startDate,
            endDate: endDate,
            rosters: rosters,
          ),
        ) {
    on<InviteEvent>(_onInviteEvent);
    on<EditTeamsEvent>(_onEditTeams);
    on<ClaimPrizeEvent>(_onClaimPrize);
    on<CalculateAppreciationEvent>(_onCalculateAppreciationEvent);
    on<JoinLeagueEvent>(_onJoinLeagueEvent);
    on<LeaveLeagueEvent>(_onLeaveTeamEvent);
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<CalculateRemainingDays>(_onCalculateRemainingDays);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);

    add(const WatchAppDataChangesStarted());
    add(FetchScoutInfoRequested());
    add(CalculateRemainingDays());
  }

  final LeagueRepository _leagueRepository;
  final Map<String, Map<String, double>> rosters;
  final GetScoutAthletesDataUseCase repo;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final CalculateTeamPerformanceUseCase _calculateTeamPerformanceUseCase;
  final String startDate;
  final String endDate;
  final TimerRepository _tickerRepository;

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

  @override
  Future<void> close() {
    _tickerRepository.cancel();
    return super.close();
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

  Future<void> _onCalculateAppreciationEvent(
    CalculateAppreciationEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final rosters = event.rosters;
    final athletes = event.athletes;
    final userTeams = <UserTeam>[];
    rosters.forEach((address, roster) {
      final teamPerformance = _calculateTeamPerformanceUseCase
          .calculateTeamPerformance(roster, athletes);
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

  Future<void> _onCalculateRemainingDays(
    CalculateRemainingDays event,
    Emitter<LeagueGameState> emit,
  ) async {
    final startDate = state.startDate;
    final endDate = state.endDate;
    _tickerRepository.timer(startDate, endDate);
    await emit.forEach<DurationStatus>(
      _tickerRepository.remainingTime,
      onData: (durationStatus) => state.coptWithTimerDuration(durationStatus),
    );
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
