import 'dart:async';

import 'dart:math';

import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  LeagueBloc({
    required LeagueRepository leagueRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required PrizePoolRepository prizePoolRepository,
  })  : _leagueRepository = leagueRepository,
        _prizePoolRepository = prizePoolRepository,
        _streamAppDataChanges = streamAppDataChanges,
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
      final leagueID = generateLeagueID(15);

      final dateStartInt =
          DateTime.parse(event.dateStart).millisecondsSinceEpoch;
      final dateEndInt = DateTime.parse(event.dateEnd).millisecondsSinceEpoch;

      final prizePoolAddress = await _prizePoolRepository.createLeague(
        event.entryFee,
        dateStartInt,
        dateEndInt,
      );
      debugPrint('the blocs prize pool address: $prizePoolAddress');

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
    await emit.onEach<List<League>>(
      _leagueRepository.fetchLeagues(),
      onData: (leagues) async {
        filterOutUnsupportedSportsByChain(leagues);
        final leagueTeams = await Future.wait(
          leagues.map((league) async {
            final leagueTeam = await _leagueRepository.fetchLeagueTeams(
              leagueID: league.leagueID,
            );
            return leagueTeam;
          }),
        );
        emit(
          state.copyWith(
            allLeagues: leagues,
            filteredLeagues: leagues,
            leagueTeams: leagueTeams,
            filteredLeagueTeams: leagueTeams,
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
          filteredLeagues: state.allLeagues
              .where(
                (league) =>
                    league.name.toUpperCase().contains(input) &&
                    event.selectedSport.name == league.sports.first.name,
              )
              .toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredLeagues: state.allLeagues
              .where(
                (league) => league.name.toUpperCase().contains(
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
      final filteredList = state.allLeagues
          .where(
            (league) => event.selectedSport.name == league.sports.first.name,
          )
          .toList();
      filterOutUnsupportedSportsByChain(filteredList);
      if (filteredList.isNotEmpty) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            filteredLeagues: filteredList,
            selectedSport: event.selectedSport,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            filteredLeagues: const [],
            selectedSport: event.selectedSport,
          ),
        );
      }
    } else {
      final filteredList = state.allLeagues
          .where((athlete) => event.selectedSport == SupportedSport.all)
          .toList();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredLeagues: filteredList,
          selectedSport: SupportedSport.all,
        ),
      );
    }
  }

  String generateLeagueID(int length) {
    const predefinedCharacters =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final random = Random();
    final generatedLeagueID = String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => predefinedCharacters.codeUnitAt(
          random.nextInt(
            predefinedCharacters.length,
          ),
        ),
      ),
    );
    return generatedLeagueID;
  }

  void filterOutUnsupportedSportsByChain(List<League> leagues) {
    if (state.selectedChain == EthereumChain.sxMainnet ||
        state.selectedChain == EthereumChain.sxTestnet) {
      leagues
          .removeWhere((element) => element.sports.first == SupportedSport.MLB);
    } else {
      leagues
          .removeWhere((element) => element.sports.first == SupportedSport.NFL);
    }
  }
}
