import 'dart:async';
import 'dart:math';

import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
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
  })  : _leagueRepository = leagueRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(const LeagueState()) {
    on<CreateLeague>(_onCreateLeague);
    on<FetchLeagues>(_onFetchLeagues);
    on<DeleteLeague>(_onDeleteLeague);
    on<UpdateLeague>(_onUpdateLeague);
    on<UpdateRoster>(_onUpdateRoster);
    on<EnrollUser>(_onEnrollUser);
    on<RemoveUser>(_onRemoveUser);
    on<SearchLeague>(_onSearchLeague);
    on<SelectedSportChanged>(_onSelectedSportChanged);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);

    add(const WatchAppDataChangesStarted());
    add(FetchLeagues());
  }

  final LeagueRepository _leagueRepository;
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
        rosters: event.rosters,
        sports: event.sports,
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
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      final leagues = await _leagueRepository.fetchLeagues();
      filterOutUnsupportedSportsByChain(leagues);
      emit(
        state.copyWith(
          allLeagues: leagues,
          filteredLeagues: leagues,
          status: BlocStatus.success,
          selectedSport: SupportedSport.all,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          allLeagues: [],
          filteredLeagues: [],
          status: BlocStatus.error,
        ),
      );
    }
  }

  Future<void> _onDeleteLeague(
    DeleteLeague event,
    Emitter<LeagueState> emit,
  ) async {
    final leagueId = event.leagueID;
    await _leagueRepository.deleteLeague(
      leagueID: leagueId,
    );
    emit(
      state.copyWith(
        status: BlocStatus.success,
      ),
    );
  }

  Future<void> _onUpdateLeague(
    UpdateLeague event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final leagueId = event.leagueID;
      final league = event.league;
      await _leagueRepository.updateLeague(
        leagueID: leagueId,
        league: league,
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onUpdateRoster(
    UpdateRoster event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final leagueId = event.leagueID;
      final userWallet = event.userWallet;

      final roster = {for (var e in event.roster) e: 0.0};

      await _leagueRepository.updateRoster(
        leagueID: leagueId,
        userWallet: userWallet,
        roster: roster,
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onEnrollUser(
    EnrollUser event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final leagueId = event.leagueID;
      final userWallet = event.userWallet;

      final roster = {for (var e in event.roster) e: 0.0};

      await _leagueRepository.enrollUser(
        leagueID: leagueId,
        userWallet: userWallet,
        roster: roster,
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onRemoveUser(
    RemoveUser event,
    Emitter<LeagueState> emit,
  ) async {
    try {
      final leagueId = event.leagueID;
      final userWallet = event.userWallet;
      await _leagueRepository.removeUser(
        leagueID: leagueId,
        userWallet: userWallet,
      );
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
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
