import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/usecases/get_scout_athletes_data_use_case.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'scout_page_event.dart';
part 'scout_page_state.dart';

class ScoutPageBloc extends Bloc<ScoutPageEvent, ScoutPageState> {
  ScoutPageBloc({
    required WalletRepository walletRepository,
    required this.repo,
  })  : _walletRepository = walletRepository,
        super(const ScoutPageState()) {
    on<WatchChainChangesStarted>(_onWatchChainChangesStarted);
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<SelectedSportChanged>(_onSelectedSportChanged);
    on<AthleteSearchChanged>(_onAthleteSearchChanged);

    add(const WatchChainChangesStarted());
    add(FetchScoutInfoRequested());
  }

  final WalletRepository _walletRepository;
  final GetScoutAthletesDataUseCase repo;

  Future<void> _onWatchChainChangesStarted(
    WatchChainChangesStarted _,
    Emitter<ScoutPageState> emit,
  ) async {
    await emit.onEach<EthereumChain>(
      _walletRepository.chainChanges,
      onData: (_) => add(FetchScoutInfoRequested()),
    );
  }

  Future<void> _onFetchScoutInfoRequested(
    FetchScoutInfoRequested _,
    Emitter<ScoutPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final response = await repo.fetchSupportedAthletes(SupportedSport.all);
      if (response.isNotEmpty) {
        emit(
          state.copyWith(
            athletes: response,
            filteredAthletes: response,
            selectedSport: SupportedSport.all,
            status: BlocStatus.success,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.noData,
            filteredAthletes: const [],
            athletes: const [],
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onSelectedSportChanged(
    SelectedSportChanged event,
    Emitter<ScoutPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      if (event.selectedSport != SupportedSport.all) {
        final filteredList = state.athletes
            .where((athlete) => event.selectedSport.name == athlete.sport.name)
            .toList();
        if (filteredList.isNotEmpty) {
          emit(
            state.copyWith(
              status: BlocStatus.success,
              filteredAthletes: filteredList,
              selectedSport: event.selectedSport,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: BlocStatus.noData,
              filteredAthletes: const [],
              selectedSport: event.selectedSport,
            ),
          );
        }
      } else {
        final filteredList = state.athletes
            .where((athlete) => event.selectedSport == SupportedSport.all)
            .toList();
        emit(
          state.copyWith(
            status: BlocStatus.success,
            filteredAthletes: filteredList,
            selectedSport: SupportedSport.all,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  void _onAthleteSearchChanged(
    AthleteSearchChanged event,
    Emitter<ScoutPageState> emit,
  ) {
    final parsedInput = event.searchedName.trim().toUpperCase();
    if (event.selectedSport != SupportedSport.all) {
      emit(
        state.copyWith(
          filteredAthletes: state.athletes
              .where(
                (athlete) =>
                    athlete.name.toUpperCase().contains(parsedInput) &&
                    event.selectedSport.name == athlete.sport.name,
              )
              .toList(),
          status: BlocStatus.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          filteredAthletes: state.athletes
              .where(
                (athlete) => athlete.name.toUpperCase().contains(parsedInput),
              )
              .toList(),
          status: BlocStatus.success,
        ),
      );
    }
  }
}
