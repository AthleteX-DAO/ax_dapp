import 'dart:async';

import 'package:ax_dapp/league/models/duration_status.dart';
import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/models/timer_status.dart';
import 'package:ax_dapp/league/models/user_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/repository/timer_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'league_game_event.dart';
part 'league_game_state.dart';

class LeagueGameBloc extends Bloc<LeagueGameEvent, LeagueGameState> {
  LeagueGameBloc({
    required LeagueRepository leagueRepository,
    required PrizePoolRepository prizePoolRepository,
    required this.repo,
    required this.startDate,
    required this.endDate,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required LeagueUseCase leagueUseCase,
    required TimerRepository timerRepository,
    required WalletRepository walletRepository,
  })  : _leagueRepository = leagueRepository,
        _prizePoolRepository = prizePoolRepository,
        _streamAppDataChanges = streamAppDataChanges,
        _leagueUseCase = leagueUseCase,
        _tickerRepository = timerRepository,
        _walletRepository = walletRepository,
        super(
          LeagueGameState(
            startDate: startDate,
            endDate: endDate,
          ),
        ) {
    on<ClaimPrizeEvent>(_onClaimPrize);
    on<CalculateAppreciationEvent>(_onCalculateAppreciationEvent);
    on<LeaveLeagueEvent>(_onLeaveTeamEvent);
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<CalculateRemainingDays>(_onCalculateRemainingDays);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<EditLeagueEvent>(_onEditLeagueEvent);
    on<FetchLeagueTeamsEvent>(_onFetchLeagueTeamsEvent);
    on<ProcessLeagueWinnerEvent>(_onProcessLeagueWinnerEvent);

    add(const WatchAppDataChangesStarted());
    add(CalculateRemainingDays());
  }

  final LeagueRepository _leagueRepository;
  final PrizePoolRepository _prizePoolRepository;
  final GetScoutAthletesDataUseCase repo;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final LeagueUseCase _leagueUseCase;
  final String startDate;
  final String endDate;
  final TimerRepository _tickerRepository;
  final WalletRepository _walletRepository;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<LeagueGameState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        _prizePoolRepository.controller.client.value =
            appConfig.reactiveWeb3Client.value;
        _prizePoolRepository.controller.credentials =
            _walletRepository.credentials.value;
        if (appData.chain.chainId != state.selectedChain.chainId) {
          emit(
            state.copyWith(
              status: BlocStatus.loading,
              selectedChain: appData.chain,
              athletes: List.empty(),
              filteredAthletes: List.empty(),
            ),
          );
        }
        add(FetchScoutInfoRequested());
      },
    );
  }

  @override
  Future<void> close() {
    _tickerRepository.cancel();
    return super.close();
  }

  Future<void> _onClaimPrize(
    ClaimPrizeEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    try {
      _prizePoolRepository
        ..winner = event.winnerAddress
        ..contractAddress = event.prizePoolAddress;
      await _prizePoolRepository.distributePrize();
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onCalculateAppreciationEvent(
    CalculateAppreciationEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final leagueTeams = event.leagueTeams;
    final athletes = event.athletes;
    final userTeams = <UserTeam>[];
    for (final team in leagueTeams) {
      final teamPerformance =
          _leagueUseCase.calculateTeamPerformance(team.roster, athletes);
      userTeams
        ..add(
          UserTeam(
            address: team.userWalletID,
            roster: team.roster,
            teamPerformance: teamPerformance + team.teamAppreciation,
          ),
        )
        ..sort((b, a) => a.teamPerformance.compareTo(b.teamPerformance));
    }
    emit(
      state.copyWith(
        userTeams: userTeams,
        status: BlocStatus.success,
      ),
    );
  }

  Future<void> _onLeaveTeamEvent(
    LeaveLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    _prizePoolRepository.contractAddress = event.prizePoolAddress;
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      await _prizePoolRepository.withdrawBeforeLeagueStarts();
      await _leagueRepository.removeUser(
        leagueID: event.leagueID,
        userWallet: event.userWalletID,
      );
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onFetchScoutInfoRequested(
    FetchScoutInfoRequested event,
    Emitter<LeagueGameState> emit,
  ) async {
    try {
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

      if (response.isNotEmpty) {
        emit(
          state.copyWith(
            athletes: response,
            filteredAthletes: response,
            status: BlocStatus.scoutsLoaded,
            selectedSport: supportedSport,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            athletes: const [],
            filteredAthletes: const [],
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
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
      onData: (durationStatus) => state.copyWithTimerDuration(durationStatus),
    );
  }

  FutureOr<void> _onEditLeagueEvent(
    EditLeagueEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    try {
      final league = League(
        leagueID: event.leagueID,
        name: event.name,
        adminWallet: event.adminWallet,
        dateStart: event.dateStart,
        dateEnd: event.dateEnd,
        teamSize: event.teamSize,
        maxTeams: event.maxTeams,
        entryFee: event.entryFee,
        isPrivate: event.isPrivate,
        isLocked: event.isLocked,
        sports: event.sports,
        winner: '',
        prizePoolAddress: event.prizePoolAddress,
      );

      await _leagueRepository.updateLeague(
        leagueID: event.leagueID,
        league: league,
      );

      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
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

  FutureOr<void> _onFetchLeagueTeamsEvent(
    FetchLeagueTeamsEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    final leagueID = event.leagueID;
    await emit.onEach<List<LeagueTeam>>(
      _leagueRepository.getLeagueTeams(leagueID: leagueID),
      onData: (leagueTeams) {
        emit(
          state.copyWith(
            status: BlocStatus.leaguesLoaded,
            leagueTeams: leagueTeams,
          ),
        );
      },
    );
  }

  FutureOr<void> _onProcessLeagueWinnerEvent(
    ProcessLeagueWinnerEvent event,
    Emitter<LeagueGameState> emit,
  ) async {
    final leagueID = event.leagueID;
    final leagueTeams = event.leagueTeams;
    final athletes = event.athletes;

    var winnerWallet = '';
    var winnerAppreciation = 0.0;

    for (final team in leagueTeams) {
      final teamPerformance =
          _leagueUseCase.calculateTeamPerformance(team.roster, athletes);

      final newAppreciation = teamPerformance + team.teamAppreciation;

      final newTeam = LeagueTeam(
        userWalletID: team.userWalletID,
        roster: team.roster,
        teamAppreciation: newAppreciation,
      );

      await _leagueRepository.updateRoster(leagueID: leagueID, team: newTeam);

      if (newAppreciation > winnerAppreciation) {
        winnerWallet = team.userWalletID;
        winnerAppreciation = newAppreciation;
      }
    }

    await _leagueRepository.updateWinnner(
      leagueID: leagueID,
      winnerWallet: winnerWallet,
    );

    emit(state.copyWith(status: BlocStatus.success));
  }
}
