import 'package:ax_dapp/scout/models/models.dart';
import 'package:ax_dapp/scout/usecases/usecases.dart';
import 'package:ax_dapp/service/controller/scout/lsp_controller.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'scout_page_event.dart';
part 'scout_page_state.dart';

class ScoutPageBloc extends Bloc<ScoutPageEvent, ScoutPageState> {
  ScoutPageBloc({
    required WalletRepository walletRepository,
    required TokensRepository tokenRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
    required this.repo,
  })  : _walletRepository = walletRepository,
        _tokenRepository = tokenRepository,
        _streamAppDataChanges = streamAppDataChanges,
        super(const ScoutPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<FetchScoutInfoRequested>(_onFetchScoutInfoRequested);
    on<SelectedSportChanged>(_onSelectedSportChanged);
    on<AthleteSearchChanged>(_onAthleteSearchChanged);

    add(const WatchAppDataChangesStarted());
    add(FetchScoutInfoRequested());
  }

  final WalletRepository _walletRepository;
  final TokensRepository _tokenRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final GetScoutAthletesDataUseCase repo;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<ScoutPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        final lspController = Get.find<LSPController>()
          ..tokenClient = appConfig.reactiveWeb3Client.value;
        lspController.controller.credentials =
            _walletRepository.credentials.value;
        if (appData.chain.chainId != state.selectedChain.chainId) {
          emit(
            state.copyWith(
              status: BlocStatus.loading,
              selectedChain: appData.chain,
              athletes: List.empty(),
              filteredAthletes: List.empty(),
            ),
          );
        }
      },
    );
  }

  Future<void> _onFetchScoutInfoRequested(
    FetchScoutInfoRequested _,
    Emitter<ScoutPageState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      var supportedSport = SupportedSport.MLB;
      debugPrint(
        'Fetching scout info for ${state.selectedChain.chainName}: ${state.selectedChain.chainId}',
      );
      switch (state.selectedChain) {
        case EthereumChain.polygonTestnet:
        case EthereumChain.polygonMainnet:
        case EthereumChain.unsupported:
          supportedSport = SupportedSport.MLB;
          break;
        case EthereumChain.sxMainnet:
        case EthereumChain.sxTestnet:
          supportedSport = SupportedSport.NFL;
          break;
        // ignore: no_default_cases
        default: // unsupported
          supportedSport = SupportedSport.MLB;
          break;
      }
      final response = await repo.fetchSupportedAthletes(supportedSport);
      final marketData = await _tokenRepository.getAxMarketData();
      final axPrice = marketData.price;

      filterOutUnsupportedSportsByChain(response);
      if (response.isNotEmpty) {
        emit(
          state.copyWith(
            athletes: response,
            filteredAthletes: response,
            selectedSport: supportedSport,
            status: BlocStatus.success,
            axPrice: axPrice,
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
        filterOutUnsupportedSportsByChain(filteredList);
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

  void filterOutUnsupportedSportsByChain(List<AthleteScoutModel> filteredList) {
    if (state.selectedChain == EthereumChain.sxMainnet ||
        state.selectedChain == EthereumChain.sxTestnet) {
      filteredList
          .removeWhere((element) => element.sport == SupportedSport.MLB);
    } else {
      filteredList
          .removeWhere((element) => element.sport == SupportedSport.NFL);
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
