import 'dart:async';
import 'dart:math';

import 'package:ax_dapp/league/models/league.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
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
    on<SearchLeague>(_onSearchLeague);
    on<SelectedSportChanged>(_onSelectedSportChanged);

    add(FetchLeagues());
  }

  final LeagueRepository _leagueRepository;

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
      emit(
        state.copyWith(
          allLeagues: leagues,
          filteredLeagues: leagues,
          status: BlocStatus.success,
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
      if (filteredList.isNotEmpty) {
        emit(
          state.copyWith(
            status: BlocStatus.success,
            filteredLeagues: filteredList,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            filteredLeagues: const [],
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
}
