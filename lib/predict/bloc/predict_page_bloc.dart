import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:ax_dapp/predict/repository/prediction_snapshot_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc({
    required WalletRepository walletRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required PredictionSnapshotRepository predictionSnapshotRepository,
    required EventMarketRepository eventMarketRepository,
  })  : _walletRepository = walletRepository,
        _streamAppDataChanges = streamAppDataChangesUseCase,
        _predictionSnapshotRepository = predictionSnapshotRepository,
        _eventMarketRepository = eventMarketRepository,
        super(const PredictPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<LoadPredictionsEvent>(_onLoadPredictions);

    add(const WatchAppDataChangesStarted());
    add(const LoadPredictionsEvent());
  }

  final WalletRepository _walletRepository;
  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final PredictionSnapshotRepository _predictionSnapshotRepository;
  final EventMarketRepository _eventMarketRepository;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        _eventMarketRepository
          ..aptFactory = appConfig.reactiveAptFactoryClient.value
          ..aptRouter = appConfig.reactiveAptRouterClient.value;
        if (appData.chain.chainId != state.selectedChain.chainId) {
          emit(
            state.copyWith(
              status: BlocStatus.loading,
              selectedChain: appData.chain,
              predictions: List.empty(),
              filteredPredictions: List.empty(),
            ),
          );
        }
      },
    );
  }

  Future<void> _onLoadPredictions(
    LoadPredictionsEvent _,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions =
          await _predictionSnapshotRepository.fetchCurrentMarkets();
      emit(
        state.copyWith(
          predictions: predictions,
          status: BlocStatus.success,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, predictions: []));
    }
  }
}
