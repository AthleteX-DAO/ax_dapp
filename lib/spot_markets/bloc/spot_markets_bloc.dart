import 'dart:async';
import 'dart:math';
import 'package:ax_dapp/api/ax_api_client.dart';
import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ax_dapp/repositories/market_price/market_price_repository.dart';
import 'package:ax_dapp/repositories/oracle/oracle_repository.dart';
import 'package:ax_dapp/spot_markets/models/spot_market_model.dart';
import 'package:ax_dapp/spot_markets/models/pending_order.dart';
import 'package:ax_dapp/spot_markets/repository/synthetix_spot_repository.dart';
import 'package:ax_dapp/util/chart/extensions/graph_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:wallet_repository/wallet_repository.dart';

part 'spot_markets_event.dart';
part 'spot_markets_state.dart';

// Synthetix v3 Ethereum Sepolia deployment constants (from SynthetixConfig)
const String SPOT_MARKET_PROXY = SynthetixConfig.spotMarketProxy;
const String CORE_PROXY = SynthetixConfig.coreProxy;
const String ORACLE_MANAGER = SynthetixConfig.oracleManager;
const String ETH_SEPOLIA_RPC = SynthetixConfig.rpcUrl;
const int ETH_SEPOLIA_CHAIN_ID = SynthetixConfig.chainId;
const String USD_PROXY = SynthetixConfig.usdProxy;

enum SpotMarketChartRange {
  day,
  sixMonths,
  oneYear,
  yearToDate,
}

// Synthetix v3 Spot Markets on Ethereum Sepolia (AthleteX ax-branded markets)
// Market IDs are dynamically assigned at deploy; synth addresses resolved on-chain
// Polygon mainnet — 15 spot markets deployed via cannon build (Feb 19 2026)
// IDs assigned alphabetically: ARB=1, AVAX=2, BTC=3, DXY=4, ETH=5, EUR=6,
//   GBP=7, LINK=8, OP=9, POLY=10, SOL=11, SPY=12, USDC=13, USDT=14, XAU=15
// synthAddress populated lazily on first load via getSynth(marketId)
const Map<String, Map<String, dynamic>> SYNTHETIX_SPOT_MARKETS = {
  // ── CRYPTO ────────────────────────────────────────────────────────────────
  'axARB': {
    'symbol': 'axARB',
    'synthAddress': '',
    'collateralAddress': '', // pure synthetic — no wrap collateral
    'marketId': 1,
    'decimals': 18,
    'baseAsset': 'ARB',
  },
  'axAVAX': {
    'symbol': 'axAVAX',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 2,
    'decimals': 18,
    'baseAsset': 'AVAX',
  },
  'axBTC': {
    'symbol': 'axBTC',
    'synthAddress': '',
    'collateralAddress': '0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6', // WBTC on Polygon
    'marketId': 3,
    'decimals': 18,
    'baseAsset': 'BTC',
  },
  'axETH': {
    'symbol': 'axETH',
    'synthAddress': '',
    'collateralAddress': '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619', // WETH on Polygon
    'marketId': 5,
    'decimals': 18,
    'baseAsset': 'ETH',
  },
  'axLINK': {
    'symbol': 'axLINK',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 8,
    'decimals': 18,
    'baseAsset': 'LINK',
  },
  'axOP': {
    'symbol': 'axOP',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 9,
    'decimals': 18,
    'baseAsset': 'OP',
  },
  'axPOLY': {
    'symbol': 'axPOLY',
    'synthAddress': '',
    'collateralAddress': '', // native MATIC wrapping not configured
    'marketId': 10,
    'decimals': 18,
    'baseAsset': 'MATIC',
  },
  'axSOL': {
    'symbol': 'axSOL',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 11,
    'decimals': 18,
    'baseAsset': 'SOL',
  },
  // ── STABLECOINS ───────────────────────────────────────────────────────────
  'axUSDC': {
    'symbol': 'axUSDC',
    'synthAddress': '',
    'collateralAddress': '0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359', // USDC on Polygon
    'marketId': 13,
    'decimals': 18,
    'baseAsset': 'USDC',
  },
  'axUSDT': {
    'symbol': 'axUSDT',
    'synthAddress': '',
    'collateralAddress': '0xc2132D05D31c914a87C6611C10748AEb04B58e8F', // USDT on Polygon
    'marketId': 14,
    'decimals': 18,
    'baseAsset': 'USDT',
  },
  // ── FOREX & INDICES ───────────────────────────────────────────────────────
  'axDXY': {
    'symbol': 'axDXY',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 4,
    'decimals': 18,
    'baseAsset': 'DXY',
  },
  'axEUR': {
    'symbol': 'axEUR',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 6,
    'decimals': 18,
    'baseAsset': 'EUR',
  },
  'axGBP': {
    'symbol': 'axGBP',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 7,
    'decimals': 18,
    'baseAsset': 'GBP',
  },
  'axSPY': {
    'symbol': 'axSPY',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 12,
    'decimals': 18,
    'baseAsset': 'SPY',
  },
  'axXAU': {
    'symbol': 'axXAU',
    'synthAddress': '',
    'collateralAddress': '',
    'marketId': 15,
    'decimals': 18,
    'baseAsset': 'XAU',
  },
};

class SpotMarketsBloc extends Bloc<SpotMarketsEvent, SpotMarketsState> {
  SpotMarketsBloc({
    WalletRepository? walletRepository,
    OracleRepository? oracleRepository,
    MarketPriceRepository? marketPriceRepository,
    AxApiClient? axApiClient,
  })  : _walletRepository = walletRepository,
        _oracleRepository = oracleRepository,
        _marketPriceRepository = marketPriceRepository,
        _axApiClient = axApiClient,
        super(const SpotMarketsInitial()) {
    on<SpotMarketsInitialize>(_onInitialize);
    on<SpotMarketsRefresh>(_onRefresh);
    on<SpotMarketSelected>(_onMarketSelected);
    on<SpotMarketBuyOrderPlaced>(_onBuyOrderPlaced);
    on<SpotMarketSellOrderPlaced>(_onSellOrderPlaced);
    on<SpotMarketOrderConfirmed>(_onOrderConfirmed);
    on<SpotMarketOrderCancelled>(_onOrderCancelled);
    on<SpotSidebarVisibilityToggled>(_onSidebarToggled);
    on<SpotMarketSingleRefresh>(_onSingleMarketRefresh);
    on<_OraclePricesUpdated>(_onOraclePricesUpdated);
    on<SpotMarketRangeSelected>(_onRangeSelected);
    on<_BatchPricesUpdated>(_onBatchPricesUpdated);
    on<_BackgroundChartLoaded>(_onBackgroundChartLoaded);

    // Initialize markets on bloc creation (mirrors AccountBloc pattern)
    add(const SpotMarketsInitialize());
  }

  final WalletRepository? _walletRepository;
  final OracleRepository? _oracleRepository;
  final MarketPriceRepository? _marketPriceRepository;
  final AxApiClient? _axApiClient;
  late Web3Client _web3Client;
  late SynthetixSpotRepository _synthetixRepo;
  late OracleRepository _oracleRepo;
  late MarketPriceRepository _marketPriceRepo;
  Timer? _pollingTimer;
  StreamSubscription<dynamic>? _eventSubscription;
  final bool _isPageFocused = true;
  List<String> _allMarkets = [];

  @override
  Future<void> close() async {
    await _eventSubscription?.cancel();
    _pollingTimer?.cancel();
    _web3Client.dispose();
    _synthetixRepo.dispose();
    await _oracleRepo.dispose();
    _marketPriceRepo.dispose();
    return super.close();
  }

  Future<void> _onInitialize(
    SpotMarketsInitialize event,
    Emitter<SpotMarketsState> emit,
  ) async {
    emit(const SpotMarketsLoading());
    try {
      _web3Client = Web3Client(ETH_SEPOLIA_RPC, http.Client());

      // Initialize oracle repository (use injected one or create new)
      _oracleRepo = _oracleRepository ?? OracleRepository();
      print('🔷 SpotMarketsBloc initialized OracleRepository');

      // Initialize market price repository (CoinGecko)
      _marketPriceRepo = _marketPriceRepository ?? MarketPriceRepository();
      print('🔷 SpotMarketsBloc initialized MarketPriceRepository');

      // Initialize Synthetix repository
      _synthetixRepo = SynthetixSpotRepository(
        rpcUrl: ETH_SEPOLIA_RPC,
        spotMarketProxyAddress: SPOT_MARKET_PROXY,
        coreProxyAddress: CORE_PROXY,
        oracleManagerAddress: ORACLE_MANAGER,
      );
      await _synthetixRepo.initialize();

      // Fetch Synthetix v3 spot markets — API-first with static fallback
      List<String> markets;
      if (_axApiClient != null) {
        try {
          final apiMarkets = await _axApiClient!.fetchSpotMarkets();
          if (apiMarkets.isNotEmpty) {
            markets = apiMarkets.map((m) => m.symbol).toList();
            print('🔷 SpotMarketsBloc loaded ${markets.length} markets from API');
          } else {
            markets = SYNTHETIX_SPOT_MARKETS.keys.toList();
          }
        } catch (e) {
          print('🔷 SpotMarketsBloc API fallback: $e');
          markets = SYNTHETIX_SPOT_MARKETS.keys.toList();
        }
      } else {
        markets = SYNTHETIX_SPOT_MARKETS.keys.toList();
      }
      final initialMarket = markets.isNotEmpty ? markets.first : '';
      
      // Fetch market data in PARALLEL (not sequential)
      print('🔷 SpotMarketsBloc parallelizing market data fetch for ${markets.length} markets');
      final marketDataFuture = _fetchSynthetixMarketData(markets);
      
      final priceHistory = <String, List<GraphData>>{};
      const selectedRange = SpotMarketChartRange.day;

      // Defer chart history to background - don't wait for it on init.
      // We schedule a separate event so emit is valid (not the init handler's emit).
      if (initialMarket.isNotEmpty) {
        Future(() async {
          try {
            final history = await _fetchMarketPriceHistory(
              initialMarket,
              selectedRange,
            );
            if (!isClosed && history.isNotEmpty) {
              add(_BackgroundChartLoaded(initialMarket, selectedRange, history));
            }
          } catch (e) {
            print('🔷 Background chart load failed, not blocking: $e');
          }
        }).ignore();
      }
      
      // Wait for parallel market data
      final marketData = await marketDataFuture;

      // Start listening to selected-market-only events and batch price polling
      _listenToMarketEventsFiltered();
      _allMarkets = markets;
      _startBatchPricePolling();

      emit(SpotMarketsLoaded(
        markets: markets,
        selectedMarket: initialMarket,
        marketData: marketData,
        priceHistory: priceHistory,
        selectedRange: selectedRange,
      ),);
    } catch (e) {
      print('SpotMarketsInitialize error: $e');
      // Extract detailed error message
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error connecting to ${SynthetixConfig.networkName}',
          details: errorDetails,
        ),);
      } else {
        emit(SpotMarketsError(
          'Failed to initialize spot markets',
          details: errorDetails,
        ),);
      }
    }
  }

  Future<void> _onSidebarToggled(
    SpotSidebarVisibilityToggled event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      emit(currentState.copyWith(showSidebar: !currentState.showSidebar));
    }
  }

  void _listenToMarketEventsFiltered() {
    _eventSubscription = _synthetixRepo.watchAllMarketEvents().listen(
      (event) {
        if (event['event'] == 'OrderSettled' && state is SpotMarketsLoaded) {
          final currentState = state as SpotMarketsLoaded;
          // Only refresh if event is for the selected market
          if (_isEventForMarket(event, currentState.selectedMarket)) {
            add(SpotMarketSingleRefresh(currentState.selectedMarket));
          }
        }
      },
      onError: (Object error) {
        // Skip 'Bad state: No element' errors - these are harmless
        final errorMsg = error.toString();
        if (!errorMsg.contains('No element')) {
          print('🔷 SpotMarketsBloc event listener error: $error');
        }
      },
      cancelOnError: false,
    );
  }

  /// Check if event relates to a specific market
  bool _isEventForMarket(Map<String, dynamic> event, String market) {
    final eventMarketId = event['marketId'] as int?;
    final marketConfig = SYNTHETIX_SPOT_MARKETS[market];
    if (marketConfig == null) return false;
    return eventMarketId == (marketConfig['marketId'] as int?);
  }

  /// Single 30-second batch poll: fetches ALL market prices in one CoinGecko call.
  /// Replaces the old staggered + oracle pollers (which made ~29 calls/min).
  /// New rate: 2 calls/min (1 batch every 30s × ticker tape's 1 batch every 30s).
  void _startBatchPricePolling() {
    if (_allMarkets.isEmpty) return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (!_isPageFocused) return;
      if (state is! SpotMarketsLoaded) return;

      // Try API batch prices first
      if (_axApiClient != null) {
        try {
          final batchPrices = await _axApiClient!.fetchBatchPrices();
          if (batchPrices.isNotEmpty) {
            final currentState = state as SpotMarketsLoaded;
            final updated = Map<String, SpotMarketModel>.from(currentState.marketData);
            var changed = false;
            for (final entry in batchPrices.entries) {
              // Find market symbol for this ID
              final symbol = SYNTHETIX_SPOT_MARKETS.entries
                  .where((e) => e.value['marketId'] == entry.key)
                  .map((e) => e.key)
                  .firstOrNull;
              if (symbol != null) {
                final price = entry.value.price / 1e18;
                final old = updated[symbol];
                if (old != null && old.currentPrice != price) {
                  updated[symbol] = old.copyWith(currentPrice: price);
                  changed = true;
                }
              }
            }
            if (changed && !isClosed) {
              add(_BatchPricesUpdated(updated));
              return; // Skip CoinGecko
            }
          }
        } catch (e) {
          print('🔷 Batch price API failed, falling back to CoinGecko: $e');
        }
      }

      try {
        final summaries = await _getMarketSummaries(_allMarkets);
        if (summaries.isEmpty || state is! SpotMarketsLoaded) return;

        final currentState = state as SpotMarketsLoaded;
        final updated = Map<String, SpotMarketModel>.from(currentState.marketData);
        var changed = false;

        for (final marketKey in _allMarkets) {
          final config = SYNTHETIX_SPOT_MARKETS[marketKey];
          if (config == null) continue;
          final baseAsset = config['baseAsset'] as String;
          final summary = summaries[baseAsset];
          if (summary == null || summary.price <= 0) continue;

          final old = updated[marketKey];
          if (old != null && old.currentPrice != summary.price) {
            updated[marketKey] = old.copyWith(
              currentPrice: summary.price,
              change24h: summary.change24h,
            );
            changed = true;
          }
        }

        if (changed) {
          add(_BatchPricesUpdated(updated));
        }
      } catch (e) {
        // Silently fail — will retry next cycle
        print('🔷 SpotMarketsBloc batch poll error: $e');
      }
    });
    print(
      '🔷 SpotMarketsBloc batch price polling: 30s interval, '
      '${_allMarkets.length} markets in 1 API call',
    );
  }

  /// Handle single market refresh from event-driven updates (e.g. OrderSettled).
  /// Fetches price once (no double-fetch) and updates state.
  Future<void> _onSingleMarketRefresh(
    SpotMarketSingleRefresh event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      try {
        final price = await _fetchSingleMarketPrice(event.market);
        if (price != null) {
          final updated = Map<String, SpotMarketModel>.from(currentState.marketData);
          final old = updated[event.market];
          if (old != null) {
            updated[event.market] = old.copyWith(currentPrice: price);
            emit(currentState.copyWith(marketData: updated));
          }
        }
      } catch (e) {
        print('Error refreshing ${event.market}: $e');
      }
    }
  }

  /// Handle batch price poll results.
  Future<void> _onBatchPricesUpdated(
    _BatchPricesUpdated event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      emit(currentState.copyWith(marketData: event.updatedData));
    }
  }

  /// Applies chart data that was loaded in the background after init.
  Future<void> _onBackgroundChartLoaded(
    _BackgroundChartLoaded event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      final updatedHistory = Map<String, List<GraphData>>.from(
        currentState.priceHistory,
      );
      updatedHistory[_historyKey(event.market, event.range)] = event.history;
      emit(currentState.copyWith(priceHistory: updatedHistory));
    }
  }

  /// Handle oracle price updates from polling timer
  Future<void> _onOraclePricesUpdated(
    _OraclePricesUpdated event,
    Emitter<SpotMarketsState> emit,
  ) async {
    try {
      emit(event.currentState.copyWith(marketData: event.updatedData));
    } catch (e) {
      print('Error emitting oracle price update: $e');
    }
  }

  Future<void> _onRefresh(
    SpotMarketsRefresh event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      try {
        final marketData =
            await _fetchSynthetixMarketData(currentState.markets);
        emit(currentState.copyWith(marketData: marketData));
      } catch (e) {
        emit(SpotMarketsError('Failed to refresh markets: $e'));
      }
    }
  }

  Future<void> _onMarketSelected(
    SpotMarketSelected event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is SpotMarketsLoaded) {
      final currentState = state as SpotMarketsLoaded;
      emit(currentState.copyWith(selectedMarket: event.market));

      final historyKey = _historyKey(event.market, currentState.selectedRange);
      if (!currentState.priceHistory.containsKey(historyKey)) {
        try {
          final history = await _fetchMarketPriceHistory(
            event.market,
            currentState.selectedRange,
          );
          if (history.isNotEmpty && state is SpotMarketsLoaded) {
            final updatedHistory =
                Map<String, List<GraphData>>.from(currentState.priceHistory);
            updatedHistory[historyKey] = history;
            emit(currentState.copyWith(priceHistory: updatedHistory));
          }
        } catch (e) {
          print('Error fetching price history for ${event.market}: $e');
        }
      }
    }
  }

  Future<void> _onRangeSelected(
    SpotMarketRangeSelected event,
    Emitter<SpotMarketsState> emit,
  ) async {
    if (state is! SpotMarketsLoaded) return;
    final currentState = state as SpotMarketsLoaded;
    final selectedMarket = currentState.selectedMarket;
    final historyKey = _historyKey(selectedMarket, event.range);

    emit(currentState.copyWith(selectedRange: event.range));

    if (!currentState.priceHistory.containsKey(historyKey)) {
      try {
        final history = await _fetchMarketPriceHistory(
          selectedMarket,
          event.range,
        );
        if (history.isNotEmpty && state is SpotMarketsLoaded) {
          final updatedHistory =
              Map<String, List<GraphData>>.from(currentState.priceHistory);
          updatedHistory[historyKey] = history;
          emit(currentState.copyWith(priceHistory: updatedHistory));
        }
      } catch (e) {
        print('Error fetching price history for $selectedMarket: $e');
      }
    }
  }

  Future<void> _onBuyOrderPlaced(
    SpotMarketBuyOrderPlaced event,
    Emitter<SpotMarketsState> emit,
  ) async {
    try {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[event.market];
      if (marketConfig == null) {
        throw Exception('Market ${event.market} not found');
      }

      // Check if wallet is connected
      if (_walletRepository == null) {
        throw Exception('Wallet not connected');
      }

      final credentials = _walletRepository!.credentials;
      final marketId = marketConfig['marketId'] as int;

      // Convert USD amount to wei (18 decimals for sUSD)
      final usdAmount =
          BigInt.from((event.price * event.quantity * 1e18).toInt());

      // Get quote first to calculate expected synth amount
      final quote = await _synthetixRepo.getQuoteBuyExactIn(
        marketId: marketId,
        usdAmount: usdAmount,
      );

      final expectedSynthAmount = quote['synthAmount'] as BigInt;
      final expectedSynthAmountDouble = expectedSynthAmount.toDouble() / 1e18;
      
      // Apply slippage tolerance (user-selected)
      // slippage is 0.01 for 1%, so (1 - 0.01) = 0.99 = 99%
      final slippageMultiplier = BigInt.from((1 - event.slippage) * 10000);
      final minSynthAmount = (expectedSynthAmount * slippageMultiplier) ~/ BigInt.from(10000);

      // Estimate gas
      final userAddress = credentials.value.address;
      final buyTransaction = Transaction.callContract(
        contract: _synthetixRepo.spotMarketContract,
        function: _synthetixRepo.spotMarketContract.function('buy'),
        parameters: [
          BigInt.from(marketId),
          usdAmount,
          minSynthAmount,
          EthereumAddress.fromHex(USD_PROXY),
        ],
        from: userAddress,
      );

      final gasEstimate = await _synthetixRepo.estimateGas(
        transaction: buyTransaction,
      );

      final orderId = _generateOrderId();
      final pendingOrder = PendingOrder(
        orderId: orderId,
        type: 'buy',
        market: event.market,
        quantity: event.quantity,
        price: event.price,
        totalCost: event.price * event.quantity,
        expectedOutput: expectedSynthAmountDouble,
        slippage: event.slippage,
        gasEstimate: {
          'gasLimit': gasEstimate['gasLimit'],
          'gasPrice': gasEstimate['gasPrice'],
          'totalCostEth': gasEstimate['totalCostEth'],
        },
        status: PendingOrderStatus.waitingForConfirmation,
        createdAt: DateTime.now(),
      );

      // Emit order awaiting confirmation
      emit(SpotMarketOrderAwaitingConfirmation(pendingOrder: pendingOrder));
    } catch (e) {
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error during buy order preparation',
          details: errorDetails,
        ),);
      } else {
        emit(SpotMarketsError(
          'Failed to prepare buy order: $e',
          details: errorDetails,
        ),);
      }
    }
  }

  /// Handle confirmed buy order execution
  Future<void> _executeBuyOrder(
    PendingOrder pendingOrder,
    Emitter<SpotMarketsState> emit,
  ) async {
    try {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[pendingOrder.market];
      if (marketConfig == null) {
        throw Exception('Market ${pendingOrder.market} not found');
      }

      if (_walletRepository == null) {
        throw Exception('Wallet not connected');
      }

      final credentials = _walletRepository!.credentials;
      final marketId = marketConfig['marketId'] as int;
      final usdAmount = BigInt.from((pendingOrder.totalCost * 1e18).toInt());
      
      // Recalculate min amount with slippage
      final quote = await _synthetixRepo.getQuoteBuyExactIn(
        marketId: marketId,
        usdAmount: usdAmount,
      );
      
      final expectedSynthAmount = quote['synthAmount'] as BigInt;
      final slippageMultiplier = BigInt.from((1 - pendingOrder.slippage) * 10000);
      final minSynthAmount = (expectedSynthAmount * slippageMultiplier) ~/ BigInt.from(10000);

      // Check allowance
      final userAddress = credentials.value.address;
      final allowance = await _synthetixRepo.getAllowance(
        tokenAddress: USD_PROXY,
        userAddress: userAddress.hex,
      );

      var updatedOrder = pendingOrder;

      if (allowance < usdAmount) {
        // Need approval
        updatedOrder = pendingOrder.copyWith(
          status: PendingOrderStatus.approvingToken,
        );
        emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

        final approveTxHash = await _synthetixRepo.approveTokenSpending(
          tokenAddress: USD_PROXY,
          amount: BigInt.from(2).pow(256) - BigInt.one,
          credentials: credentials.value,
        );

        updatedOrder = pendingOrder.copyWith(
          status: PendingOrderStatus.approvingToken,
          approvalTxHash: approveTxHash,
        );
        emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

        // Wait for approval
        await _waitForTransaction(approveTxHash);
      }

      // Execute buy order
      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.executingOrder,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      final txHash = await _synthetixRepo.executeBuyOrder(
        marketId: marketId,
        usdAmount: usdAmount,
        minSynthAmount: minSynthAmount,
        credentials: credentials.value,
      );

      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.pending,
        txHash: txHash,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      // Wait for confirmation
      await _waitForTransaction(txHash);

      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.confirmed,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      // Update state with new pending order and refresh markets
      if (state is SpotMarketsLoaded) {
        final currentState = state as SpotMarketsLoaded;
        final updatedOrders = [...currentState.pendingOrders, updatedOrder];
        emit(currentState.copyWith(pendingOrders: updatedOrders));
      }

      add(const SpotMarketsRefresh());
    } catch (e) {
      final errorOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.failed,
        errorMessage: e.toString(),
      );
      emit(SpotMarketOrderProcessing(pendingOrder: errorOrder));
    }
  }

  Future<void> _onSellOrderPlaced(
    SpotMarketSellOrderPlaced event,
    Emitter<SpotMarketsState> emit,
  ) async {
    try {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[event.market];
      if (marketConfig == null) {
        throw Exception('Market ${event.market} not found');
      }

      if (_walletRepository == null) {
        throw Exception('Wallet not connected');
      }

      final credentials = _walletRepository!.credentials;
      final marketId = marketConfig['marketId'] as int;
      final decimals = marketConfig['decimals'] as int;

      // Convert synth amount to smallest units
      final synthAmount =
          BigInt.from((event.quantity * pow(10, decimals)).toInt());

      // Get quote first to calculate expected USD amount
      final quote = await _synthetixRepo.getQuoteSellExactIn(
        marketId: marketId,
        synthAmount: synthAmount,
      );

      final expectedUsdAmount = quote['usdAmount'] as BigInt;
      final expectedUsdAmountDouble = expectedUsdAmount.toDouble() / 1e18;
      
      // Apply slippage tolerance (user-selected)
      final slippageMultiplier = BigInt.from((1 - event.slippage) * 10000);
      final minUsdAmount = (expectedUsdAmount * slippageMultiplier) ~/ BigInt.from(10000);

      // Estimate gas
      final userAddress = credentials.value.address;
      final sellTransaction = Transaction.callContract(
        contract: _synthetixRepo.spotMarketContract,
        function: _synthetixRepo.spotMarketContract.function('sell'),
        parameters: [
          BigInt.from(marketId),
          synthAmount,
          minUsdAmount,
          EthereumAddress.fromHex(USD_PROXY),
        ],
        from: userAddress,
      );

      final gasEstimate = await _synthetixRepo.estimateGas(
        transaction: sellTransaction,
      );

      final orderId = _generateOrderId();
      final pendingOrder = PendingOrder(
        orderId: orderId,
        type: 'sell',
        market: event.market,
        quantity: event.quantity,
        price: event.price,
        totalCost: event.quantity, // For sell, this is the quantity of synth
        expectedOutput: expectedUsdAmountDouble,
        slippage: event.slippage,
        gasEstimate: {
          'gasLimit': gasEstimate['gasLimit'],
          'gasPrice': gasEstimate['gasPrice'],
          'totalCostEth': gasEstimate['totalCostEth'],
        },
        status: PendingOrderStatus.waitingForConfirmation,
        createdAt: DateTime.now(),
      );

      // Emit order awaiting confirmation
      emit(SpotMarketOrderAwaitingConfirmation(pendingOrder: pendingOrder));
    } catch (e) {
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error during sell order preparation',
          details: errorDetails,
        ),);
      } else {
        emit(SpotMarketsError(
          'Failed to prepare sell order: $e',
          details: errorDetails,
        ),);
      }
    }
  }

  /// Handle confirmed sell order execution
  Future<void> _executeSellOrder(
    PendingOrder pendingOrder,
    Emitter<SpotMarketsState> emit,
  ) async {
    try {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[pendingOrder.market];
      if (marketConfig == null) {
        throw Exception('Market ${pendingOrder.market} not found');
      }

      if (_walletRepository == null) {
        throw Exception('Wallet not connected');
      }

      final credentials = _walletRepository!.credentials;
      final marketId = marketConfig['marketId'] as int;
      final synthAddress = marketConfig['synthAddress'] as String;
      final decimals = marketConfig['decimals'] as int;

      // Convert synth amount to smallest units
      final synthAmount =
          BigInt.from((pendingOrder.totalCost * pow(10, decimals)).toInt());

      // Recalculate quote
      final quote = await _synthetixRepo.getQuoteSellExactIn(
        marketId: marketId,
        synthAmount: synthAmount,
      );

      final expectedUsdAmount = quote['usdAmount'] as BigInt;
      final slippageMultiplier = BigInt.from((1 - pendingOrder.slippage) * 10000);
      final minUsdAmount = (expectedUsdAmount * slippageMultiplier) ~/ BigInt.from(10000);

      // Check allowance
      final userAddress = credentials.value.address;
      final allowance = await _synthetixRepo.getAllowance(
        tokenAddress: synthAddress,
        userAddress: userAddress.hex,
      );

      var updatedOrder = pendingOrder;

      if (allowance < synthAmount) {
        // Need approval
        updatedOrder = pendingOrder.copyWith(
          status: PendingOrderStatus.approvingToken,
        );
        emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

        final approveTxHash = await _synthetixRepo.approveTokenSpending(
          tokenAddress: synthAddress,
          amount: BigInt.from(2).pow(256) - BigInt.one,
          credentials: credentials.value,
        );

        updatedOrder = pendingOrder.copyWith(
          status: PendingOrderStatus.approvingToken,
          approvalTxHash: approveTxHash,
        );
        emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

        // Wait for approval
        await _waitForTransaction(approveTxHash);
      }

      // Execute sell order
      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.executingOrder,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      final txHash = await _synthetixRepo.executeSellOrder(
        marketId: marketId,
        synthAmount: synthAmount,
        minUsdAmount: minUsdAmount,
        credentials: credentials.value,
      );

      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.pending,
        txHash: txHash,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      // Wait for confirmation
      await _waitForTransaction(txHash);

      updatedOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.confirmed,
      );
      emit(SpotMarketOrderProcessing(pendingOrder: updatedOrder));

      // Update state with new pending order and refresh markets
      if (state is SpotMarketsLoaded) {
        final currentState = state as SpotMarketsLoaded;
        final updatedOrders = [...currentState.pendingOrders, updatedOrder];
        emit(currentState.copyWith(pendingOrders: updatedOrders));
      }

      add(const SpotMarketsRefresh());
    } catch (e) {
      final errorOrder = pendingOrder.copyWith(
        status: PendingOrderStatus.failed,
        errorMessage: e.toString(),
      );
      emit(SpotMarketOrderProcessing(pendingOrder: errorOrder));
    }
  }

  /// Wait for transaction confirmation
  Future<void> _waitForTransaction(String txHash) async {
    var receipt = await _web3Client.getTransactionReceipt(txHash);
    var attempts = 0;

    while (receipt == null && attempts < 30) {
      await Future<void>.delayed(const Duration(seconds: 2));
      receipt = await _web3Client.getTransactionReceipt(txHash);
      attempts++;
    }

    if (receipt == null) {
      throw Exception('Transaction confirmation timeout');
    }

    if (!receipt.status!) {
      throw Exception('Transaction failed');
    }
  }

  /// Fetch real market data from Synthetix v3 on Polygon Mainnet
  /// Price priority: CoinGecko → Oracle (Chainlink/Pyth) → On-chain quote → Mock
  Future<Map<String, SpotMarketModel>> _fetchSynthetixMarketData(
    List<String> markets,
  ) async {
    final data = <String, SpotMarketModel>{};

    // Fetch market summaries (prices + 24h change)
    final marketSummaries = await _getMarketSummaries(markets);

    for (final marketKey in markets) {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[marketKey];
      if (marketConfig == null) continue;

      final baseAsset = marketConfig['baseAsset'] as String;
      final summary = marketSummaries[baseAsset];

      // 3-tier price fallback: CoinGecko → Oracle → On-chain quote → Mock
      double price;
      try {
        if (summary != null && summary.price > 0) {
          price = summary.price;
        } else {
          // Try oracle (Chainlink/Pyth) before on-chain quote
          price = await _getPriceFromOracle(baseAsset) ??
              await _getPriceFromSpotQuote(marketConfig);
        }
      } catch (e) {
        print('🔷 SpotMarketsBloc price fetch failed for $marketKey: $e, using mock');
        price = _getSynthetixMockPrice(marketKey);
      }

      final change24h = summary?.change24h ?? 0.0;

      data[marketKey] = SpotMarketModel(
        symbol: marketKey,
        currentPrice: price,
        change24h: change24h,
        high24h: price * 1.05,
        low24h: price * 0.95,
        volume24h: price * (50000 + (marketKey.hashCode.abs() % 200000)),
      );
    }

    return data;
  }

  /// Try to get price from the OracleRepository (Chainlink/Pyth fallback chain).
  /// Returns null if oracle has no feed configured for this asset.
  Future<double?> _getPriceFromOracle(String baseAsset) async {
    try {
      final priceFeed = await _oracleRepo.getPrice(baseAsset);
      if (priceFeed.price > 0) {
        return priceFeed.price;
      }
    } catch (_) {
      // Oracle doesn't have a feed for this asset — fall through
    }
    return null;
  }

  /// Fetch a single market price with oracle fallback
  /// 
  /// Returns: Price double or null on failure
  Future<double?> _fetchSingleMarketPrice(String marketKey) async {
    final marketConfig = SYNTHETIX_SPOT_MARKETS[marketKey];
    if (marketConfig == null) return null;

    try {
      final baseAsset = marketConfig['baseAsset'] as String;

      // Try market summary first
      final summaries = await _marketPriceRepo.fetchMarketSummaries([baseAsset]);
      final summary = summaries[baseAsset];
      if (summary != null && summary.price > 0) {
        return summary.price;
      }

      // Fallback to Synthetix quote
      return await _getPriceFromSpotQuote(marketConfig);
    } catch (e) {
      print('🔷 SpotMarketsBloc price fetch failed for $marketKey: $e');
      return null;
    }
  }

  /// Fetch market summaries (price + 24h change) for a list of markets
  /// Returns empty map on failure - page will use on-chain quotes instead
  Future<Map<String, MarketSummary>> _getMarketSummaries(
    List<String> markets,
  ) async {
    final symbolsToFetch = <String>{};

    // Extract unique base assets from markets
    for (final market in markets) {
      final config = SYNTHETIX_SPOT_MARKETS[market];
      if (config != null) {
        final baseAsset = config['baseAsset'] as String;
        symbolsToFetch.add(baseAsset);
      }
    }

    if (symbolsToFetch.isEmpty) {
      print('🔷 SpotMarketsBloc no symbols to fetch market summaries for');
      return {};
    }

    try {
      print('🔷 SpotMarketsBloc fetching market summaries for: ${symbolsToFetch.join(', ')}');
      final summaries = await _marketPriceRepo.fetchMarketSummaries(symbolsToFetch.toList());
      print('🔷 SpotMarketsBloc successfully fetched ${summaries.length} market summaries');
      return summaries;
    } catch (e) {
      print('⚠️ SpotMarketsBloc error fetching market summaries (will use on-chain data): $e');
      return {};
    }
  }

  /// Fetch price history for chart based on selected range
  /// Returns empty list on failure - chart will show "No data available"
  Future<List<GraphData>> _fetchMarketPriceHistory(
    String marketKey,
    SpotMarketChartRange range,
  ) async {
    final marketConfig = SYNTHETIX_SPOT_MARKETS[marketKey];
    if (marketConfig == null) return [];

    final baseAsset = marketConfig['baseAsset'] as String;
    try {
      final days = _daysForRange(range);
      final history = await _marketPriceRepo.fetchMarketChart(baseAsset, days: days);
      print('🔷 SpotMarketsBloc fetched ${history.length} price points for $marketKey');
      return history;
    } catch (e) {
      print('⚠️ SpotMarketsBloc error fetching price history for $marketKey (chart will be empty): $e');
      return [];
    }
  }

  int _daysForRange(SpotMarketChartRange range) {
    switch (range) {
      case SpotMarketChartRange.day:
        return 1;
      case SpotMarketChartRange.sixMonths:
        return 180;
      case SpotMarketChartRange.oneYear:
        return 365;
      case SpotMarketChartRange.yearToDate:
        final now = DateTime.now();
        final start = DateTime(now.year);
        return now.difference(start).inDays.clamp(1, 365);
    }
  }

  String _historyKey(String marketKey, SpotMarketChartRange range) {
    return '${marketKey}_${range.name}';
  }

  /// Derive a price from SpotMarketProxy quotes
  /// Quotes selling exactly 1.0 synth to get USD price
  Future<double> _getPriceFromSpotQuote(
      Map<String, dynamic> marketConfig,) async {
    final marketId = marketConfig['marketId'] as int;
    final decimals = marketConfig['decimals'] as int;
    // Quote selling exactly 1.0 synth (10^decimals base units) to USD
    final oneSynth = BigInt.from(10).pow(decimals);
    final quote = await _synthetixRepo.getQuoteSellExactIn(
      marketId: marketId,
      synthAmount: oneSynth,
    );
    final usdAmount = quote['usdAmount'] as BigInt;
    // USD has 18 decimals in Synthetix v3
    return usdAmount.toDouble() / 1e18;
  }

  /// Fallback mock prices for Synthetix v3 ax-branded spot markets.
  /// Used only when both CoinGecko and on-chain quotes fail.
  double _getSynthetixMockPrice(String market) {
    switch (market) {
      case 'axUSDC':
      case 'axUSDT':
        return 1;
      case 'axBTC':
        return 97000;
      case 'axETH':
        return 2600;
      case 'axSOL':
        return 200;
      case 'axLINK':
        return 18;
      case 'axARB':
        return 1.2;
      case 'axAVAX':
        return 40;
      case 'axOP':
        return 2.5;
      case 'axPOLY':
        return 0.7;
      case 'axDXY':
        return 104;
      case 'axEUR':
        return 1.08;
      case 'axGBP':
        return 1.27;
      case 'axSPY':
        return 530;
      case 'axXAU':
        return 2350;
      default:
        return 100;
    }
  }

  /// Handle order confirmation from dialog
  Future<void> _onOrderConfirmed(
    SpotMarketOrderConfirmed event,
    Emitter<SpotMarketsState> emit,
  ) async {
    // Find the pending order
    if (state is! SpotMarketsLoaded) return;
    final currentState = state as SpotMarketsLoaded;
    
    PendingOrder? pendingOrder;
    try {
      pendingOrder = currentState.pendingOrders
          .firstWhere((o) => o.orderId == event.orderId);
    } catch (e) {
      return; // Order not found
    }

    // Execute the order based on type
    if (pendingOrder.type == 'buy') {
      await _executeBuyOrder(pendingOrder, emit);
    } else if (pendingOrder.type == 'sell') {
      await _executeSellOrder(pendingOrder, emit);
    }
  }

  /// Handle order cancellation
  Future<void> _onOrderCancelled(
    SpotMarketOrderCancelled event,
    Emitter<SpotMarketsState> emit,
  ) async {
    // Remove the pending order
    if (state is! SpotMarketsLoaded) return;
    final currentState = state as SpotMarketsLoaded;
    
    final updatedOrders = currentState.pendingOrders
        .where((o) => o.orderId != event.orderId)
        .toList();
    
    emit(currentState.copyWith(pendingOrders: updatedOrders));
  }

  String _generateOrderId() {
    return 'SNX-${DateTime.now().millisecondsSinceEpoch}';
  }
}
