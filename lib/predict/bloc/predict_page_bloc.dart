import 'package:ax_dapp/predict/data/prediction_market_client.dart';
import 'package:ax_dapp/predict/livestream/livestream.dart';
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
  PredictPageBloc({
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required EventMarketRepository eventMarketRepository,
    required GetPredictionMarketInfoUseCase getPredictionMarketInfoUseCase,
    required this.getPredictionMarketDataUseCase,
    PredictionMarketClient? predictionMarketClient,
    LiveStreamRepository? liveStreamRepository,
  })  : _streamAppDataChanges = streamAppDataChangesUseCase,
        _eventMarketRepository = eventMarketRepository,
        _getPredictionMarketInfoUseCase = getPredictionMarketInfoUseCase,
        _predictionMarketClient = predictionMarketClient,
        _liveStreamRepository = liveStreamRepository,
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

    on<AllPredictionMarketsRequested>(_onAllPredictionMarketsRequested);

    on<PredictionVisibilityChanged>(_onPredictionVisibilityChanged);

    on<PredictionPlacementRequested>(_onPredictionPlacementRequested);

    on<LiveStreamsFetchRequested>(_onLiveStreamsFetchRequested);

    add(const WatchAppDataChangesStarted());
    add(const AllPredictionMarketsRequested());
    add(const LiveStreamsFetchRequested());
  }

  final StreamAppDataChangesUseCase _streamAppDataChanges;
  final EventMarketRepository _eventMarketRepository;
  final GetPredictionMarketInfoUseCase _getPredictionMarketInfoUseCase;
  final GetPredictionMarketDataUseCase getPredictionMarketDataUseCase;
  final PredictionMarketClient? _predictionMarketClient;
  final LiveStreamRepository? _liveStreamRepository;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChanges.appDataChanges,
      onData: (appData) {
        final appConfig = appData.appConfig;
        final aptFactory = appConfig.reactiveAptFactoryClient.valueOrNull;
        final aptRouter = appConfig.reactiveAptRouterClient.valueOrNull;
        if (aptFactory != null && aptRouter != null) {
          _eventMarketRepository
            ..aptFactory = aptFactory
            ..aptRouter = aptRouter;
        }
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
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.college);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onBasketballPredictionMarketsRequested(
    BasketballPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions =
          await getPredictionMarketDataUseCase.fetchSupportedPredictionMarkets(
        SupportedPredictionMarkets.basketball,
      );
      emit(
        state.copyWith(
          status: BlocStatus.success,
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
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.football);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onHockeyPredictionMarketsRequested(
    HockeyPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.hockey);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onBaseballPredictionMarketsRequested(
    BaseballPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.baseball);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onSoccerPredictionMarketsRequested(
    SoccerPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.soccer);
      emit(
        state.copyWith(
          status: BlocStatus.success,
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
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.voted);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
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
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.exotic);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onAllPredictionMarketsRequested(
    AllPredictionMarketsRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    emit(
      state.copyWith(status: BlocStatus.loading),
    );
    try {
      final predictions = await getPredictionMarketDataUseCase
          .fetchSupportedPredictionMarkets(SupportedPredictionMarkets.all);
      emit(
        state.copyWith(
          status: BlocStatus.success,
          filteredPredictions: predictions,
        ),
      );
    } catch (e) {
      debugPrint('$e');
      emit(state.copyWith(status: BlocStatus.error, filteredPredictions: []));
    }
  }

  Future<void> _onPredictionVisibilityChanged(
    PredictionVisibilityChanged event,
    Emitter<PredictPageState> emit,
  ) async {
    final updatedVisibility = Set<int>.from(state.visiblePredictionIds);
    if (event.isVisible) {
      updatedVisibility.add(event.predictionId);
    } else {
      updatedVisibility.remove(event.predictionId);
    }
    emit(state.copyWith(visiblePredictionIds: updatedVisibility));
  }

  /// Handle bet placement: approve axUSD → create tokens on-chain.
  Future<void> _onPredictionPlacementRequested(
    PredictionPlacementRequested event,
    Emitter<PredictPageState> emit,
  ) async {
    if (_predictionMarketClient == null) {
      debugPrint('PredictionMarketClient not available — cannot place prediction');
      return;
    }

    // Use the Controller's credentials for the wallet-connected user
    final credentials = _eventMarketRepository.controller.credentials;
    final axUsdAddress = '0x1Ea27b8fa8D9Fb4370Dd654ffFad4734D0960fA6';
    final amount =
        BigInt.from(event.axUsdAmount * 1e18);

    try {
      debugPrint(
        'Placing bet: ${event.axUsdAmount} axUSD on '
        '${event.isYes ? "YES" : "NO"} for market ${event.marketAddress}',
      );

      // Step 1: Approve axUSD spend (amount + 1% fee buffer)
      final approveAmount =
          amount + (amount * BigInt.from(2)) ~/ BigInt.from(100);
      final approveTx = await _predictionMarketClient!.approveAxUsd(
        axUsdAddress: axUsdAddress,
        spenderAddress: event.marketAddress,
        amount: approveAmount,
        credentials: credentials,
      );
      debugPrint('Approve tx: $approveTx');

      // Step 2: Create tokens (mints equal YES + NO)
      final createTx = await _predictionMarketClient!.createTokens(
        marketAddress: event.marketAddress,
        tokensToCreate: amount,
        credentials: credentials,
      );
      debugPrint('Create tx: $createTx');

      // Refresh market data after successful bet
      add(const AllPredictionMarketsRequested());
    } catch (e) {
      debugPrint('Bet placement failed: $e');
    }
  }

  Future<void> _onLiveStreamsFetchRequested(
    LiveStreamsFetchRequested _,
    Emitter<PredictPageState> emit,
  ) async {
    if (_liveStreamRepository == null) return;
    try {
      final streams = await _liveStreamRepository!.fetchActiveStreams();
      emit(state.copyWith(activeStreams: streams));
    } catch (e) {
      debugPrint('LiveStream fetch failed: $e');
      // Non-blocking — don't change page status
    }
  }
}
