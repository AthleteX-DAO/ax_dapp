import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:flutter/widgets.dart';
import 'package:shared/shared.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'predict_page_event.dart';
part 'predict_page_state.dart';

class PredictPageBloc extends Bloc<PredictPageEvent, PredictPageState> {
  PredictPageBloc(
      {required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
      required EventMarketRepository eventMarketRepository,
      required GetPredictionMarketInfoUseCase getPredictionMarketInfoUseCase,
      required this.getPredictionMarketDataUseCase})
      : _streamAppDataChanges = streamAppDataChangesUseCase,
        _eventMarketRepository = eventMarketRepository,
        _getPredictionMarketInfoUseCase = getPredictionMarketInfoUseCase,
        super(const PredictPageState()) {
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<SelectedPredictionMarketsChanged>(_onSelectedPredictionMarketsChanged);

    on<CollegePredictionMarketsRequested>(_onCollegePredictionMarketsRequested);

    on<BasketballPredictionMarketsRequested>(
      _onBasketballPredictionMarketsRequested,
    );

    on<FootballPredictionMarketsRequested>(
      _onFootballPredictionMarketsRequested,
    );

    on<HockeyPredictionMarketsRequested>(_onHockeyPredictionMarketsRequested);

    on<BaseballPredictionMarketsRequested>(
      _onBaseballPredictionMarketsRequested,
    );

    on<SoccerPredictionMarketsRequested>(_onSoccerPredictionMarketsRequested);

    on<VotedPredictionMarketsRequested>(_onVotedPredictionMarketsRequested);

    on<ExoticPredictionMarketsRequested>(_onExoticPredictionMarketsRequested);

    on<FetchPredictionInfoRequested>(_onFetchPredictionInfoRequested);

    add(const WatchAppDataChangesStarted());
    add(const FetchPredictionInfoRequested());
  }

  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final EventMarketRepository _eventMarketRepository;
  final GetPredictionMarketInfoUseCase _getPredictionMarketInfoUseCase;
  final GetPredictionMarketDataUseCase getPredictionMarketDataUseCase;

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

  Future<void> _onFetchPredictionInfoRequested(
    FetchPredictionInfoRequested _,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions =
          await _getPredictionMarketInfoUseCase.fetchPredictionModel();
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

  Future<void> _onSelectedPredictionMarketsChanged(
    SelectedPredictionMarketsChanged event,
    Emitter<PredictPageState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );
      emit(
        state.copyWith(
          status: BlocStatus.success,
          selectedMarket: event.selectedMarkets,
        ),
      );
    } catch (error) {
      debugPrint('ERROR SELECTING MARKETS $error');
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onCollegePredictionMarketsRequested(
    CollegePredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
  }

  Future<void> _onBasketballPredictionMarketsRequested(
    BasketballPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = <PredictionModel>[
        PredictionModel.empty,
        PredictionModel.empty,
        PredictionModel.empty,
      ];

      debugPrint('PREDICTIONS LIST: $predictions');
      emit(
        state.copyWith(
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onFootballPredictionMarketsRequested(
    FootballPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
  }

  Future<void> _onHockeyPredictionMarketsRequested(
    HockeyPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
  }

  Future<void> _onBaseballPredictionMarketsRequested(
    BaseballPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
  }

  Future<void> _onSoccerPredictionMarketsRequested(
    SoccerPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.soccer);
      emit(
        state.copyWith(
          predictions: predictions,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onVotedPredictionMarketsRequested(
    VotedPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions =
          await _getPredictionMarketInfoUseCase.fetchPredictionModel();

      debugPrint('PREDICTIONS LIST: $predictions');
      emit(
        state.copyWith(
          filteredPredictions: predictions,
          status: BlocStatus.success,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onExoticPredictionMarketsRequested(
    ExoticPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
  }
}
