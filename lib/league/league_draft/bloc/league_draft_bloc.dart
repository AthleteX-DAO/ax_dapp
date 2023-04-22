import 'dart:async';

import 'package:ax_dapp/league/models/draft_apt.dart';
import 'package:ax_dapp/league/models/league_team.dart';
import 'package:ax_dapp/league/repository/league_repository.dart';
import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/calculate_team_performance_usecase.dart';
import 'package:ax_dapp/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/service/controller/usecases/get_max_token_input_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'league_draft_event.dart';
part 'league_draft_state.dart';

class LeagueDraftBloc extends Bloc<LeagueDraftEvent, LeagueDraftState> {
  LeagueDraftBloc({
    required LeagueRepository leagueRepository,
    required PrizePoolRepository prizePoolRepository,
    required GetTotalTokenBalanceUseCase getTotalTokenBalanceUseCase,
    required CalculateTeamPerformanceUseCase calculateTeamPerformanceUseCase,
    required this.athletes,
  })  : _leagueRepository = leagueRepository,
        _prizePoolRepository = prizePoolRepository,
        _getTotalTokenBalanceUseCase = getTotalTokenBalanceUseCase,
        _calculateTeamPerformanceUseCase = calculateTeamPerformanceUseCase,
        super(const LeagueDraftState()) {
    on<FetchAptsOwnedEvent>(_onFetchAptsOwnedEvent);
    on<AddAptToTeam>(_onAddAptToTeam);
    on<RemoveAptFromTeam>(_onRemoveAptFromTeam);
    on<ConfirmTeam>(_onConfirmTeam);
    add(FetchAptsOwnedEvent(athletes: athletes));
  }

  final LeagueRepository _leagueRepository;
  final PrizePoolRepository _prizePoolRepository;
  final GetTotalTokenBalanceUseCase _getTotalTokenBalanceUseCase;
  final CalculateTeamPerformanceUseCase _calculateTeamPerformanceUseCase;
  final List<AthleteScoutModel> athletes;

  Future<void> _onFetchAptsOwnedEvent(
    FetchAptsOwnedEvent event,
    Emitter<LeagueDraftState> emit,
  ) async {
    final athletes = event.athletes;
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      final response = await _getTotalTokenBalanceUseCase.getOwnedApts();
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
  ) {
    if (state.athleteCount < event.teamSize) {
      emit(state.copyWith(status: BlocStatus.loading));
      final apt = event.apt;
      final ownedApts = List<DraftApt>.from(state.ownedApts)..remove(apt);
      final myAptTeam = List<DraftApt>.from(state.myAptTeam)..add(apt);
      final athleteCount = myAptTeam.length;
      emit(
        state.copyWith(
          ownedApts: ownedApts,
          myAptTeam: myAptTeam,
          athleteCount: athleteCount,
          status: BlocStatus.success,
        ),
      );
    }
  }

  void _onRemoveAptFromTeam(
    RemoveAptFromTeam event,
    Emitter<LeagueDraftState> emit,
  ) {
    emit(state.copyWith(status: BlocStatus.loading));
    final apt = event.apt;
    final ownedApts = List<DraftApt>.from(state.ownedApts)..add(apt);
    final myAptTeam = List<DraftApt>.from(state.myAptTeam)..remove(apt);
    final athleteCount = myAptTeam.length;
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
  ) async {
    final userWalletID = event.walletAddress;
    final leagueID = event.leagueID;
    final myTeam = event.myTeam;
    final existingTeam = event.existingTeam;

    final roster = {
      for (var e in myTeam) e.id: [e.name, e.bookPrice.toString()]
    };
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final teamAppreciation = _calculateTeamPerformanceUseCase
              .calculateTeamPerformance(roster, athletes) +
          existingTeam.teamAppreciation;

      if (existingTeam.userWalletID == '') {}

      final team = LeagueTeam(
        userWalletID: userWalletID,
        teamAppreciation: teamAppreciation,
        roster: roster,
      );
      await _leagueRepository.enrollUser(
        leagueID: leagueID,
        team: team,
      );
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
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
      final id = e.type == AptType.long ? int.parse('${athlete.id}1') : int.parse('${athlete.id}0');
      return DraftApt(
        id: id,
        name: aptName,
        team: athlete.team,
        sport: athlete.sport,
        bookPrice: bookPrice,
        bookPricePercent: bookPricePercent,
      );
    }).toList();
  }
}
