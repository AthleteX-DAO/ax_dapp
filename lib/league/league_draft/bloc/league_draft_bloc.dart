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
  ) {}

  void _onRemoveAptFromTeam(
    RemoveAptFromTeam event,
    Emitter<LeagueDraftState> emit,
  ) {}

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
    final ownedApts = <DraftApt>[];

    for (final apt in response) {
      for (final athlete in athletes) {
        if (apt.athleteId == athlete.id) {
          final double? bookPrice;
          final double? bookPricePercent;

          switch (apt.type) {
            case AptType.long:
              {
                bookPrice = athlete.longTokenBookPrice;
                bookPricePercent = athlete.longTokenBookPricePercent;
              }
              break;

            case AptType.short:
              {
                bookPrice = athlete.shortTokenBookPrice;
                bookPricePercent = athlete.shortTokenBookPricePercent;
              }
              break;

            case AptType.none:
              {
                bookPrice = 0;
                bookPricePercent = 0;
              }
              break;
          }

          var name = apt.name;
          name = name.replaceAll('APT', '')..trim();

          ownedApts.add(
            DraftApt(
              id: athlete.id,
              name: name,
              team: athlete.team,
              sport: athlete.sport,
              bookPrice: bookPrice,
              bookPricePercent: bookPricePercent,
            ),
          );
        }
      }
    }
    return ownedApts;
  }
}
