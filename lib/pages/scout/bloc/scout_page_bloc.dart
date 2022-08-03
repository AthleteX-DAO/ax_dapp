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
    on<WatchEthereumChainChangesStarted>(_onWatchEthereumChainChangesStarted);
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<SelectSport>(_mapSelectSportToState);
    on<OnAthleteSearch>(_mapSearchAthleteEventToState);

    add(const WatchEthereumChainChangesStarted());
    add(FetchScoutInfoRequested());
  }

  final WalletRepository _walletRepository;
  final GetScoutAthletesDataUseCase repo;

  Future<void> _onWatchEthereumChainChangesStarted(
    WatchEthereumChainChangesStarted _,
    Emitter<ScoutPageState> emit,
  ) async {
    await emit.onEach<EthereumChain>(
      _walletRepository.ethereumChainChanges,
      onData: (_) => add(FetchScoutInfoRequested()),
    );
  }

  Future<void> _onFetchScoutInfoRequested(
    FetchScoutInfoRequested event,
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
            filteredAthletes: [],
            athletes: [],
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _mapSelectSportToState(
    SelectSport event,
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
              filteredAthletes: [],
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

  void _mapSearchAthleteEventToState(
    OnAthleteSearch event,
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
