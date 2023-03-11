import 'dart:async';

import 'package:ax_dapp/pages/league/models/league.dart';
import 'package:ax_dapp/pages/league/repository/league_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
    final name = event.name;
    final adminWallet = event.adminWallet;
    final dateStart = event.dateStart;
    final dateEnd = event.dateEnd;
    final teamSize = event.teamSize;
    final maxTeams = event.maxTeams;
    final entryFee = event.entryFee;
    final isPrivate = event.isPrivate;
    final isLocked = event.isLocked;
    final league = League(
      name: name,
      adminWallet: adminWallet,
      dateStart: dateStart,
      dateEnd: dateEnd,
      teamSize: teamSize,
      maxTeams: maxTeams,
      entryFee: entryFee,
      isPrivate: isPrivate,
      isLocked: isLocked,
      rosters: [],
    );
    await _leagueRepository.createLeague(league: league);
  }
}
