import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/repositories/mlb_repo.dart';
import 'package:ax_dapp/repositories/nfl_repo.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tokens_repository/tokens_repository.dart';

part 'athlete_page_event.dart';
part 'athlete_page_state.dart';

class AthletePageBloc extends Bloc<AthletePageEvent, AthletePageState> {
  AthletePageBloc({
    required TokensRepository tokensRepository,
    required this.mlbRepo,
    required this.nflRepo,
    required this.athlete,
  })  : _tokensRepository = tokensRepository,
        super(
          // setting the apt corresponding to the default aptType which is long
          AthletePageState(
            longApt: tokensRepository.aptPair(athlete.id).longApt,
          ),
        ) {
    on<WatchAptPairStarted>(_onWatchAptPairStarted);
    on<AptTypeSelectionChanged>(_onAptTypeSelectionChanged);
    on<OnPageRefresh>(_mapPageRefreshEventToState);
    on<OnGraphRefresh>(_mapGraphRefreshEventToState);

    add(WatchAptPairStarted(athlete.id));
  }

  final AthleteScoutModel athlete;

  final TokensRepository _tokensRepository;
  final MLBRepo mlbRepo;
  final NFLRepo nflRepo;

  Future<void> _onWatchAptPairStarted(
    WatchAptPairStarted event,
    Emitter<AthletePageState> emit,
  ) async {
    await emit.forEach<AptPair>(
      _tokensRepository.aptPairChanges(event.athleteId),
      onData: (aptPair) =>
          state.copyWith(longApt: aptPair.longApt, shortApt: aptPair.shortApt),
    );
  }

  void _onAptTypeSelectionChanged(
    AptTypeSelectionChanged event,
    Emitter<AthletePageState> emit,
  ) {
    emit(state.copyWith(aptTypeSelection: event.aptType));
  }

  Future<void> _mapPageRefreshEventToState(
    OnPageRefresh event,
    Emitter<AthletePageState> emit,
  ) async {
    switch (athlete.sport) {
      case SupportedSport.all:
        break;

      case SupportedSport.NFL:
        try {
          final playerId = event.playerId;
          emit(state.copyWith(status: BlocStatus.loading));
          final now = DateTime.now();
          final startDate = DateTime(now.year, now.month - 10, now.day);
          final formattedDate = DateFormat('yyyy-MM-dd').format(now);
          final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
          final until = formattedDate;
          final from = formattedStartDate;
          final stats = await nflRepo.getPlayerStatsHistory(
            playerId,
            from,
            until,
          );
          final graphStats = stats.statHistory
              .map(
                (stat) => GraphData(
                  DateFormat('yyy-MM-dd').parse(stat.timeStamp),
                  stat.price * 10000,
                ),
              )
              .toList();
          final seenDates = <DateTime>{};
          final distinctPoints = graphStats
              .where((element) => seenDates.add(element.date))
              .toList();
          emit(
            state.copyWith(
              stats: distinctPoints,
              status: BlocStatus.success,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: BlocStatus.error));
        }
        break;

      case SupportedSport.MLB:
        try {
          final playerId = event.playerId;
          emit(state.copyWith(status: BlocStatus.loading));
          final now = DateTime.now();
          final startDate = DateTime(now.year, now.month - 1, now.day);
          final formattedDate = DateFormat('yyyy-MM-dd').format(now);
          final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
          final until = formattedDate;
          final from = formattedStartDate;
          final stats = await mlbRepo.getPlayerStatsHistory(
            playerId,
            from,
            until,
          );
          final graphStats = stats.statHistory
              .map(
                (stat) => GraphData(
                  DateFormat('yyy-MM-dd').parse(stat.timeStamp),
                  stat.price * 1000,
                ),
              )
              .toList();
          final seenDates = <DateTime>{};
          final distinctPoints = graphStats
              .where((element) => seenDates.add(element.date))
              .toList();
          emit(
            state.copyWith(
              stats: distinctPoints,
              status: BlocStatus.success,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: BlocStatus.error));
        }
        break;

      case SupportedSport.NBA:
        break;
    }
  }

  void _mapGraphRefreshEventToState(
    OnGraphRefresh event,
    Emitter<AthletePageState> emit,
  ) {}
}
