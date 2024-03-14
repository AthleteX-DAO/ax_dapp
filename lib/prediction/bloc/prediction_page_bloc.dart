import 'dart:async';

import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';

part 'prediction_page_event.dart';
part 'prediction_page_state.dart';

class PredictionPageBloc
    extends Bloc<PredictionPageEvent, PredictionPageState> {
  PredictionPageBloc({
    required WalletRepository walletRepository,
    required EventMarketRepository eventMarketRepository,
    required StreamAppDataChangesUseCase streamAppDataChangesUseCase,
    required PredictionAddressRepository predictionAddressRepository,
    required this.predictionModelId,
    required this.getPredictionMarketDataUseCase,
  })  : _walletRepository = walletRepository,
        _eventMarketRepository = eventMarketRepository,
        _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        _predictionAddressRepository = predictionAddressRepository,
        super(const PredictionPageState()) {
    // This area is subject to reform
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<PredictionPageLoaded>(_onPredictionPageLoaded);
    on<LoadingPredictionPage>(_onLoadingPredictionPage);
    on<MintPredictionTokens>(_onMintPredictionTokens);
    on<RedeemPredictionTokens>(_onRedeemPredictionTokens);
    on<LoadMarketAddress>(_onLoadMarketAddress);
    on<ToggleAdvanceFeatures>(_onToggleAdvanceFeatured);
    // End region

    on<GetEventStatsRequested>(_onGetEventStatsRequested);

    add(const WatchAppDataChangesStarted());
    add(LoadMarketAddress());
    //Load Prediction Graph
    add(GetEventStatsRequested(predictionModelId));
  }

  final WalletRepository _walletRepository;
  final EventMarketRepository _eventMarketRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final GetPredictionMarketDataUseCase getPredictionMarketDataUseCase;
  final PredictionAddressRepository _predictionAddressRepository;
  final int predictionModelId;

  Future<void> _onWatchAppDataChangesStarted(
    WatchAppDataChangesStarted _,
    Emitter<PredictionPageState> emit,
  ) async {
    await emit.onEach<AppData>(
      _streamAppDataChangesUseCase.appDataChanges,
      onData: (appData) {
        emit(
          state.copyWith(
            status: BlocStatus.loading,
            yesAddress: kNullAddress,
            noAddress: kNullAddress,
          ),
        );
        final appConfig = appData.appConfig;
        _eventMarketRepository
          ..aptFactory = appConfig.reactiveAptFactoryClient.value
          ..aptRouter = appConfig.reactiveAptRouterClient.value
          ..eventBasedPredictionMarket =
              appConfig.reactiveEventMarketsClient.value
          ..controller.client.value = appConfig.reactiveWeb3Client.value
          ..controller.credentials = _walletRepository.credentials.value
          ..marketAddress.value = state.predictionModel.marketAddress;
      },
    );
  }

  Future<void> _onMintPredictionTokens(
    MintPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    await _eventMarketRepository.mint();
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> _onRedeemPredictionTokens(
    RedeemPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    await _eventMarketRepository.redeem();
    emit(state.copyWith(status: BlocStatus.success));
  }

  Future<void> _onLoadingPredictionPage(
    LoadingPredictionPage event,
    Emitter<PredictionPageState> emit,
  ) async {}

  Future<void> _onPredictionPageLoaded(
    PredictionPageLoaded event,
    Emitter<PredictionPageState> emit,
  ) async {
    final predictionAddress = event.predictionModel.marketAddress;
    final currentPrediction = event.predictionModel;
    _eventMarketRepository.eventMarketAddress = predictionAddress;
    emit(
      state.copyWith(
        status: BlocStatus.success,
        predictionModel: currentPrediction,
      ),
    );
  }

  Future<void> _onLoadMarketAddress(
    LoadMarketAddress event,
    Emitter<PredictionPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    try {
      final marketAddresses = await _predictionAddressRepository
          .fetchMarketAddresses(predictionModelId);
      _eventMarketRepository
        ..yesMarketAddress = marketAddresses[0]
        ..noMarketAddress = marketAddresses[1];
      emit(
        state.copyWith(
          yesAddress: marketAddresses[0],
          noAddress: marketAddresses[1],
          status: BlocStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          yesAddress: '',
          noAddress: '',
          status: BlocStatus.error,
        ),
      );
    }
  }

  void _onToggleAdvanceFeatured(
    ToggleAdvanceFeatures event,
    Emitter<PredictionPageState> emit,
  ) {
    emit(state.copyWith(isToggled: !state.isToggled));
  }

  Future<void> _onGetEventStatsRequested(
    GetEventStatsRequested event,
    Emitter<PredictionPageState> emit,
  ) async {
    final eventId = event.predictionId;

    emit(state.copyWith(status: BlocStatus.loading));

    const startDate = '2023-12-01';
    final marketRecords = await getPredictionMarketDataUseCase
        .getMarketPriceHistory(startDate, eventId);
    updatePriceGraphData(marketRecords, emit);

    /// Get event price stats as empty
  }

  void updatePriceGraphData(
    MarketPriceRecord marketPriceRecord,
    Emitter<PredictionPageState> emit,
  ) {
    final yesHistory = marketPriceRecord.yesRecord.priceHistory;
    final noHistory = marketPriceRecord.noRecord.priceHistory;

    final graphStats = <String, GraphData>{};
    for (final record in yesHistory) {
      final date = DateTime.parse(record.timestamp);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      if (graphStats.containsKey(dateStr)) {
        graphStats.update(
          dateStr,
          (value) =>
              GraphData(date, value.price, longMarketPrice: record.price),
        );
      } else {
        graphStats[dateStr] = GraphData(date, 0, longMarketPrice: record.price);
      }
    }

    for (final record in noHistory) {
      final date = DateTime.parse(record.timestamp);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      if (graphStats.containsKey(dateStr)) {
        graphStats.update(
          dateStr,
          (value) => GraphData(
            date,
            value.price,
            longMarketPrice: value.longMarketPrice,
            shortMarketPrice: record.price,
          ),
        );
      } else {
        graphStats[dateStr] = GraphData(
          date,
          0,
          shortMarketPrice: record.price,
        );
      }
    }

    final keys = graphStats.keys.toList().sorted((a, b) => a.compareTo(b));
    for (var i = 1; i < keys.length; i++) {
      final prevData = graphStats[keys[i - 1]];
      graphStats.update(keys[i], (data) {
        return GraphData(
          data.date,
          data.price == 0 ? prevData!.price : data.price,
          longMarketPrice: data.longMarketPrice == 0
              ? prevData!.longMarketPrice
              : data.longMarketPrice,
          shortMarketPrice: data.shortMarketPrice == 0
              ? prevData!.shortMarketPrice
              : data.shortMarketPrice,
        );
      });
    }

    for (var i = keys.length - 2; i >= 0; i--) {
      final nextData = graphStats[keys[i + 1]];
      graphStats.update(keys[i], (data) {
        return GraphData(
          data.date,
          data.price == 0 ? nextData!.price : data.price,
          longMarketPrice: data.longMarketPrice == 0
              ? nextData!.longMarketPrice
              : data.longMarketPrice,
          shortMarketPrice: data.shortMarketPrice == 0
              ? nextData!.shortMarketPrice
              : data.shortMarketPrice,
        );
      });
    }

    final distinctPoints =
        keys.asMap().entries.map((e) => graphStats[e.value]!).toList();
    emit(
      state.copyWith(
        stats: distinctPoints,
        status: BlocStatus.success,
      ),
    );
  }
}
