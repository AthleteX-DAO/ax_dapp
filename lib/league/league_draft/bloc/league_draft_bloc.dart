import 'dart:async';

import 'package:ax_dapp/league/repository/prize_pool_repository.dart';
import 'package:ax_dapp/league/usecases/league_use_case.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/service/controller/usecases/get_total_token_balance_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:league_repository/league_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'league_draft_event.dart';
part 'league_draft_state.dart';

class LeagueDraftBloc extends Bloc<LeagueDraftEvent, LeagueDraftState> {
  LeagueDraftBloc({
    required LeagueRepository leagueRepository,
    required PrizePoolRepository prizePoolRepository,
    required GetTotalTokenBalanceUseCase getTotalTokenBalanceUseCase,
    required LeagueUseCase leagueUseCase,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required WalletRepository walletRepository,
    required this.isEditing,
    required this.athletes,
    required this.leagueTeam,
    required this.league,
  })  : _leagueRepository = leagueRepository,
        _prizePoolRepository = prizePoolRepository,
        _getTotalTokenBalanceUseCase = getTotalTokenBalanceUseCase,
        _leagueUseCase = leagueUseCase,
        _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        _walletRepository = walletRepository,
        super(LeagueDraftState(league: league)) {
    on<FetchAptsOwnedEvent>(_onFetchAptsOwnedEvent);
    on<AddAptToTeam>(_onAddAptToTeam);
    on<RemoveAptFromTeam>(_onRemoveAptFromTeam);
    on<ConfirmTeam>(_onConfirmTeam);
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    add(const WatchAppDataChangesStarted());
    add(FetchAptsOwnedEvent(athletes: athletes, leagueTeam: leagueTeam));
  }

  final LeagueRepository _leagueRepository;
  final PrizePoolRepository _prizePoolRepository;
  final GetTotalTokenBalanceUseCase _getTotalTokenBalanceUseCase;
  final LeagueUseCase _leagueUseCase;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final WalletRepository _walletRepository;
  final List<AthleteScoutModel> athletes;
  final bool isEditing;
  final LeagueTeam leagueTeam;
  final League league;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted event,
    Emitter<LeagueDraftState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChangesUseCase.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        _prizePoolRepository.controller.client.value =
            appConfig.reactiveWeb3Client.value;
        _prizePoolRepository.controller.credentials =
            _walletRepository.credentials.value;
      },
    );
  }

  Future<void> _onFetchAptsOwnedEvent(
    FetchAptsOwnedEvent event,
    Emitter<LeagueDraftState> emit,
  ) async {
    final athletes = event.athletes;
    final leagueTeam = event.leagueTeam;
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      final response = await _getTotalTokenBalanceUseCase.getOwnedApts();
      final ownedApts = _leagueUseCase.ownedAptToList(response, athletes);
      final filteredOwnedApts = ownedApts
          .where((apt) => state.league.sports.contains(apt.sport))
          .toList();
      if (isEditing) {
        final rosterIds = leagueTeam.rosterIds;
        final existingAptTeam = filteredOwnedApts.getExistingAptTeam(rosterIds);
        final availableOwnedApts =
            filteredOwnedApts.getAvailableOwnedApts(rosterIds);
        final existingTeamSize = existingAptTeam.length;
        emit(
          state.copyWith(
            ownedApts: availableOwnedApts,
            myAptTeam: existingAptTeam,
            athleteCount: existingTeamSize,
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            ownedApts: filteredOwnedApts,
            status: BlocStatus.success,
          ),
        );
      }
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
    final prizePoolAddress = event.prizePoolAddress;
    final entryFee = event.entryFee.toDouble();
    final tokenDecimal = await _walletRepository
        .getDecimals('0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909');

    final roster = {
      for (var e in myTeam) e.id: [e.name, e.bookPrice.toString()]
    };
    try {
      if (isEditing) {
        final teamAppreciation =
            _leagueUseCase.calculateTeamPerformance(roster, athletes) +
                existingTeam.teamAppreciation;
        final team = LeagueTeam(
          userWalletID: userWalletID,
          teamAppreciation: teamAppreciation,
          roster: roster,
        );
        await _leagueRepository.updateRoster(
          leagueID: leagueID,
          team: team,
        );
      } else {
        emit(state.copyWith(status: BlocStatus.loading));

        final teamAppreciation =
            _leagueUseCase.calculateTeamPerformance(roster, athletes) +
                existingTeam.teamAppreciation;

        if (existingTeam.userWalletID == '') {}

        _prizePoolRepository
          ..entryAmount = entryFee
          ..contractAddress = prizePoolAddress
          ..tokenDecimals = tokenDecimal.toInt();

        await _prizePoolRepository.approve();
        final didJoinLeague = await _prizePoolRepository.joinLeague();
        final team = LeagueTeam(
          userWalletID: userWalletID,
          teamAppreciation: teamAppreciation,
          roster: roster,
        );
        if (didJoinLeague) {
          await _leagueRepository.enrollUser(
            leagueID: leagueID,
            team: team,
          );
        }
      }
      emit(state.copyWith(status: BlocStatus.success));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
