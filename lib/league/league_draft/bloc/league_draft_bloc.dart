// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'league_draft_event.dart';
part 'league_draft_state.dart';

class LeagueDraftBloc extends Bloc<LeagueDraftEvent, LeagueDraftState> {
  LeagueDraftBloc({
    required LeagueRepository leagueRepository,
    required GetTotalTokenBalanceUseCase getTotalTokenBalanceUseCase,
  })  : _leagueRepository = leagueRepository,
        _getTotalTokenBalanceUseCase = getTotalTokenBalanceUseCase,
        super(const LeagueDraftState()) {
    on<FetchAptsOwnedEvent>(_onFetchAptsOwnedEvent);
    on<AddAptToTeam>(_onAddAptToTeam);
    on<RemoveAptFromTeam>(_onRemoveAptFromTeam);
    on<ConfirmTeam>(_onConfirmTeam);
    on<GetAthletes>(_onGetAthletes);
  }

  final LeagueRepository _leagueRepository;
  final GetTotalTokenBalanceUseCase _getTotalTokenBalanceUseCase;

  Future<void> _onFetchAptsOwnedEvent(
    FetchAptsOwnedEvent event,
    Emitter<LeagueDraftState> emit,
  ) async {
    final athletes = event.athletes;

    try {
      emit(state.copyWith(status: BlocStatus.loading));
      final response = await _getTotalTokenBalanceUseCase.getOwnedApts();
      debugPrint('$response');
      final ownedApts = ownedAptToList(response, athletes);
      debugPrint('\n\n$ownedApts');

      emit(state.copyWith(ownedApts: ownedApts, status: BlocStatus.success));
    } catch (_) {
      emit(
        state.copyWith(
          ownedApts: [],
          status: BlocStatus.error,
        ),
      );
    }
  }

  void _onAddAptToTeam(
    AddAptToTeam event,
    Emitter<LeagueDraftState> emit,
  ) {
    emit(state.copyWith(status: BlocStatus.loading));
    final apt = event.apt;
    final ownedApts = List<DraftApt>.from(state.ownedApts)..remove(apt);

    final myAptTeam = List<DraftApt>.from(state.myAptTeam)..add(apt);

    final athleteCount = state.myAptTeam.length;

    emit(
      state.copyWith(
        ownedApts: ownedApts,
        myAptTeam: myAptTeam,
        athleteCount: athleteCount,
        status: BlocStatus.success,
      ),
    );
  }

  void _onRemoveAptFromTeam(
    RemoveAptFromTeam event,
    Emitter<LeagueDraftState> emit,
  ) {
    emit(state.copyWith(status: BlocStatus.loading));
    final apt = event.apt;
    final ownedApts = List<DraftApt>.from(state.ownedApts)..add(apt);

    final myAptTeam = List<DraftApt>.from(state.myAptTeam)..remove(apt);

    final athleteCount = state.myAptTeam.length;

    emit(
      state.copyWith(
        ownedApts: ownedApts,
        myAptTeam: myAptTeam,
        athleteCount: athleteCount,
        status: BlocStatus.success,
      ),
    );
  }

  Future<void> _onConfirmTeam(
    ConfirmTeam event,
    Emitter<LeagueDraftState> emit,
  ) async {}

  void _onGetAthletes(
    GetAthletes event,
    Emitter<LeagueDraftState> emit,
  ) {
    final athletes = event.athletes;
    emit(state.copyWith(athletes: athletes));
  }

  List<DraftApt> ownedAptToList(
    List<Apt> response,
    List<AthleteScoutModel> athletes,
  ) {
    return response
        .where((apt) => athletes.any((element) => element.id == apt.athleteId))
        .map((e) {
      final athlete = athletes.firstWhere(
        (athlete) => athlete.id == e.athleteId,
        orElse: () => AthleteScoutModel.empty,
      );
      final bookPrice = e.type == AptType.long
          ? athlete.longTokenBookPrice
          : e.type == AptType.short
              ? athlete.shortTokenBookPrice
              : 0.0;
      final bookPricePercent = e.type == AptType.long
          ? athlete.longTokenBookPricePercent
          : e.type == AptType.short
              ? athlete.shortTokenBookPricePercent
              : 0.0;
      final aptName = e.name.replaceAll('APT', '').trim();
      return DraftApt(
        id: athlete.id,
        name: aptName,
        team: athlete.team,
        sport: athlete.sport,
        bookPrice: bookPrice,
        bookPricePercent: bookPricePercent,
      );
    }).toList();
  }
}
