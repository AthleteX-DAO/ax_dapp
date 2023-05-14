import 'dart:async';

import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:league_repository/league_repository.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  LeagueBloc({
    required LeagueRepository leagueRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required PrizePoolRepository prizePoolRepository,
    required LeagueUseCase leagueUseCase,
  })  : _leagueRepository = leagueRepository,
        _prizePoolRepository = prizePoolRepository,
        _streamAppDataChanges = streamAppDataChanges,
        _leagueUseCase = leagueUseCase,
        super(const LeagueState()) {
    on<CreateLeague>(_onCreateLeague);
    on<FetchLeagues>(_onFetchLeagues);
    on<SearchLeague>(_onSearchLeague);
    on<SelectedSportChanged>(_onSelectedSportChanged);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);

    add(const WatchAppDataChangesStarted());
    add(FetchLeagues());
  }

  final LeagueRepository _leagueRepository;
  final PrizePoolRepository _prizePoolRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final LeagueUseCase _leagueUseCase;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<LeagueState> emit,
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

  Future<void> _onCreateLeague(
    CreateLeague event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final leagueID = _leagueUseCase.generateLeagueID(15);

      final dateStartInt =
          DateTime.parse(event.dateStart).millisecondsSinceEpoch;
      final dateEndInt = DateTime.parse(event.dateEnd).millisecondsSinceEpoch;

      final prizePoolAddress = await _prizePoolRepository.createLeague(
        entryFeeAmount: event.entryFee,
        leagueStartTime: dateStartInt,
        leagueEndTime: dateEndInt,
      );

      final league = League(
        leagueID: leagueID,
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
        prizePoolAddress: prizePoolAddress,
      );

      await _leagueRepository.createLeague(league: league);

      add(FetchLeagues());
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onFetchLeagues(
    FetchLeagues event,
    Emitter<LeagueState> emit,
  ) async {
    await emit.onEach<List<Pair<League, List<LeagueTeam>>>>(
      _leagueRepository.getLeaguesWithTeams(),
      onData: (leaguesWithTeams) async {
        emit(
          state.copyWith(
            leaguesWithTeams: leaguesWithTeams,
            filteredLeaguesWithTeams: leaguesWithTeams,
            status: BlocStatus.success,
            selectedSport: SupportedSport.all,
          ),
        );
      },
    );
  }

  Future<void> _onSearchLeague(
    SearchLeague event,
    Emitter<LeagueState> emit,
  ) async {
    final input = event.input.trim().toUpperCase();
    if (event.selectedSport != SupportedSport.all) {
      emit(
        state.copyWith(
          filteredLeaguesWithTeams: state.leaguesWithTeams
              .where(
                (pair) =>
                    pair.first.name.toUpperCase().contains(input) &&
                    event.selectedSport.name == pair.first.sports.first.name,
              )
              .toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredLeaguesWithTeams: state.leaguesWithTeams
              .where(
                (pair) => pair.first.name.toUpperCase().contains(
                      input.toUpperCase(),
                    ),
              )
              .toList(),
        ),
      );
    }
  }

  Future<void> _onSelectedSportChanged(
    SelectedSportChanged event,
    Emitter<LeagueState> emit,
  ) async {
    if (event.selectedSport != SupportedSport.all) {
      final filteredLeaguesWithTeams = state.leaguesWithTeams
          .where(
            (pair) => event.selectedSport.name == pair.first.sports.first.name,
          )
          .toList();
      filterOutUnsupportedSportsByChain(filteredLeaguesWithTeams);
      if (filteredLeaguesWithTeams.isNotEmpty) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            filteredLeaguesWithTeams: filteredLeaguesWithTeams,
            selectedSport: event.selectedSport,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            filteredLeaguesWithTeams: const [],
            selectedSport: event.selectedSport,
          ),
        );
      }
    } else {
      final filteredLeaguesWithTeams = state.leaguesWithTeams
          .where((pair) => event.selectedSport == SupportedSport.all)
          .toList();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredLeaguesWithTeams: filteredLeaguesWithTeams,
          selectedSport: SupportedSport.all,
        ),
      );
    }
  }

  void filterOutUnsupportedSportsByChain(
    List<Pair<League, List<LeagueTeam>>> leaguesWithTeams,
  ) {
    if (state.selectedChain == EthereumChain.sxMainnet ||
        state.selectedChain == EthereumChain.sxTestnet) {
      leaguesWithTeams
          .removeWhere((pair) => pair.first.sports.first == SupportedSport.MLB);
    } else {
      leaguesWithTeams
          .removeWhere((pair) => pair.first.sports.first == SupportedSport.NFL);
    }
  }
}
