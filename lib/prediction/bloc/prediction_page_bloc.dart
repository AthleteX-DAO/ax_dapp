import 'dart:async';

import 'package:ax_dapp/predict/models/models.dart';
import 'package:ax_dapp/predict/data/prediction_order_client.dart';
import 'package:ax_dapp/predict/usecase/get_prediction_market_data_use_case.dart';
import 'package:ax_dapp/prediction/repository/prediction_address_repository.dart';
import 'package:ax_dapp/service/controller/predictions/event_market_repository.dart';
import 'package:ax_dapp/util/bloc_status.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

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
    required TokensRepository tokensRepository,
    PredictionOrderClient? predictionOrderClient,
  })  : _walletRepository = walletRepository,
        _eventMarketRepository = eventMarketRepository,
        _streamAppDataChangesUseCase = streamAppDataChangesUseCase,
        _predictionAddressRepository = predictionAddressRepository,
        _tokensRepository = tokensRepository,
        _predictionOrderClient = predictionOrderClient,
        super(const PredictionPageState()) {
    // This area is subject to reform
    on<WatchAppDataChangesStarted>(_onWatchAppDataChangesStarted);
    on<PredictionPageLoaded>(_onPredictionPageLoaded);
    on<LoadingPredictionPage>(_onLoadingPredictionPage);
    on<MintPredictionTokens>(_onMintPredictionTokens);
    on<RedeemPredictionTokens>(_onRedeemPredictionTokens);
    on<BuyPredictionTokens>(_onBuyPredictionTokens);
    on<SellPredictionTokens>(_onSellPredictionTokens);
    on<LoadMarketAddress>(_onLoadMarketAddress);
    on<ToggleAdvanceFeatures>(_onToggleAdvanceFeatured);
    // End region

    on<GetEventStatsRequested>(_onGetEventStatsRequested);

    add(const WatchAppDataChangesStarted());
    add(LoadMarketAddress());
    //Load Prediction Graph
    add(GetEventStatsRequested(predictionModelId));
  }

  final TokensRepository _tokensRepository;
  final WalletRepository _walletRepository;
  final EventMarketRepository _eventMarketRepository;
  final StreamAppDataChangesUseCase _streamAppDataChangesUseCase;
  final GetPredictionMarketDataUseCase getPredictionMarketDataUseCase;
  final PredictionAddressRepository _predictionAddressRepository;
  final PredictionOrderClient? _predictionOrderClient;
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
        final aptFactory = appConfig.reactiveAptFactoryClient.valueOrNull;
        final aptRouter = appConfig.reactiveAptRouterClient.valueOrNull;
        if (aptFactory != null && aptRouter != null) {
          _eventMarketRepository
            ..aptFactory = aptFactory
            ..aptRouter = aptRouter
            ..eventBasedPredictionMarket =
                appConfig.reactiveEventMarketsClient.value
            ..controller.client.value = appConfig.reactiveWeb3Client.value
            ..controller.credentials = _walletRepository.credentials.value
            ..marketAddress.value = state.predictionModel.marketAddress;
        }
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
    final startDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 30)));
    
    // Try to fetch from Firebase if market address available, otherwise fall back to mock
    final marketAddress = state.predictionModel?.marketAddress;
    final marketRecords = marketAddress != null
        ? await getPredictionMarketDataUseCase.getPriceHistoryFromFirebase(
            marketAddress,
            DateTime.now().subtract(const Duration(days: 30)),
            eventId,
          )
        : await getPredictionMarketDataUseCase.getMockMarketPriceHistory(
            startDate,
            eventId,
          );
    
    updatePriceGraphData(marketRecords, emit);

    /// Get event price stats from QuestDB (or mock fallback)
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

  Future<void> _onBuyPredictionTokens(
    BuyPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    
    try {
      debugPrint(
        'Buying ${event.axUsdAmount} of ${event.isYes ? 'YES' : 'NO'} tokens',
      );

      // Try API-routed path first
      final marketAddress = state.predictionModel?.marketAddress;
      final wallet = _walletRepository.credentials.value;
      if (_predictionOrderClient != null && marketAddress != null && wallet != null) {
        final amountWei = BigInt.from(event.axUsdAmount * 1e18).toString();
        final orderResponse = await _predictionOrderClient!.buildBuyOrder(
          marketId: marketAddress,
          outcome: event.isYes ? 'yes' : 'no',
          axusdAmountWei: amountWei,
          wallet: wallet.address.hex,
        );

        if (orderResponse != null && orderResponse.transactions.isNotEmpty) {
          debugPrint('API-routed buy: ${orderResponse.transactions.length} txs');
          final client = _eventMarketRepository.controller.client.value;
          final credentials = _eventMarketRepository.controller.credentials;
          
          // Sign and send each transaction
          for (final unsignedTx in orderResponse.transactions) {
            debugPrint('Sending tx: ${unsignedTx.description}');
            final tx = Transaction(
              to: EthereumAddress.fromHex(unsignedTx.to),
              data: hexToBytes(unsignedTx.data),
              value: EtherAmount.inWei(BigInt.parse(unsignedTx.value)),
            );
            
            final txHash = await client.sendTransaction(
              credentials,
              tx,
              chainId: orderResponse.chainId,
            );
            debugPrint('Tx hash: $txHash');
          }
          emit(state.copyWith(status: BlocStatus.success));
          add(GetEventStatsRequested(predictionModelId));
          return;
        }
      }

      // Fallback to direct Web3 calls
      final axtAddress = _tokensRepository.currentTokens.axt.address;
      final targetTokenAddress = event.isYes ? state.yesAddress : state.noAddress;
      
      _eventMarketRepository
        ..address1.value = axtAddress
        ..address2.value = targetTokenAddress
        ..amount1.value = event.axUsdAmount;
      
      await _eventMarketRepository.approve(
        _eventMarketRepository.aptRouter.self.address.hex,
        event.axUsdAmount,
      );
      await _eventMarketRepository.buy();
      
      emit(state.copyWith(status: BlocStatus.success));
      
      // Refresh market data after buy
      add(GetEventStatsRequested(predictionModelId));
    } catch (e) {
      debugPrint('Error buying tokens: $e');
      emit(state.copyWith(status: BlocStatus.error));
    }
  }

  Future<void> _onSellPredictionTokens(
    SellPredictionTokens event,
    Emitter<PredictionPageState> emit,
  ) async {
    // Currently, sell is handled via SellPredictionDialog which uses SellDialogBloc.
    // If desktop UI uses this handler in the future, it is now wired.
    emit(state.copyWith(status: BlocStatus.loading));
    
    try {
      debugPrint('Selling prediction tokens');
      final axtAddress = _tokensRepository.currentTokens.axt.address;
      // We assume YES token is being sold here for demonstration
      final targetTokenAddress = state.yesAddress;
      
      _eventMarketRepository
        ..address1.value = targetTokenAddress
        ..address2.value = axtAddress;
      
      await _eventMarketRepository.approve(
        _eventMarketRepository.aptRouter.self.address.hex,
        _eventMarketRepository.amount1.value,
      );
      await _eventMarketRepository.sell();
      
      emit(state.copyWith(status: BlocStatus.success));
      
      // Refresh market data after sell
      add(GetEventStatsRequested(predictionModelId));
    } catch (e) {
      debugPrint('Error selling tokens: $e');
      emit(state.copyWith(status: BlocStatus.error));
    }
  }
}
