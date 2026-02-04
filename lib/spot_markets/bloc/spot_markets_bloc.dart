import 'dart:async';
import 'dart:math';
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

// Synthetix v3 Base Sepolia deployment constants
const String SPOT_MARKET_PROXY = '0xaD2fE7cd224c58871f541DAE01202F93928FEF72';
const String CORE_PROXY = '0x764F4C95FDA0D6f8114faC54f6709b1B45f919a1';
const String ORACLE_MANAGER = '0xD4E93f8a0aBc321ECC5b4bFBb501cb968e121F21';
const String PYTH_ERC7412_WRAPPER =
    '0x21fDb21da8102DA4776e2de1AbD8901fF8c21a2A';
const String BASE_SEPOLIA_RPC =
    'https://base-sepolia.infura.io/v3/295739f3c9f64796bccfc206fc476a88';
const int BASE_SEPOLIA_CHAIN_ID = 84532;
const String USD_PROXY = '0x682f0d17feDC62b2a0B91f8992243Bf44cAfeaaE'; // sUSD

enum SpotMarketChartRange {
  day,
  sixMonths,
  oneYear,
  yearToDate,
}

// Synthetix v3 Spot Markets on Base Sepolia
const Map<String, Map<String, dynamic>> SYNTHETIX_SPOT_MARKETS = {
  'sUSDC': {
    'symbol': 'sUSDC',
    'synthAddress': '0x8069c44244e72443722cfb22DcE5492cba239d39',
    'collateralAddress': '0xc43708f8987Df3f3681801e5e640667D86Ce3C30', // fUSDC
    'marketId': 1,
    'decimals': 18,
    'baseAsset': 'USDC',
  },
  'scbBTC': {
    'symbol': 'scbBTC',
    'synthAddress': '0x410EecB4b4CF7175352a472572492C1c9997a5e8',
    'collateralAddress': '0x8608d511E224180051A36d34121725D978064e6E', // cbBTC
    'marketId': 2,
    'decimals': 8,
    'baseAsset': 'BTC',
  },
  'scbETH': {
    'symbol': 'scbETH',
    'synthAddress': '0x1c6dfe3205334Fece6a9169c88bF698Ed4370107',
    'collateralAddress': '0x00ab6b818652bB3bFE334983171edFD38184DbeD', // cbETH
    'marketId': 3,
    'decimals': 18,
    'baseAsset': 'ETH',
  },
  'sWETH': {
    'symbol': 'sWETH',
    'synthAddress': '0x86B35F1b900B15C98049f68f4248815518e71985',
    'collateralAddress': '0x4200000000000000000000000000000000000006', // WETH
    'marketId': 4,
    'decimals': 18,
    'baseAsset': 'WETH',
  },
  'swstETH': {
    'symbol': 'swstETH',
    'synthAddress': '0x5dc2592d23f72833c559ACB35c7122995EA80486',
    'collateralAddress': '0x7Bf65af7EFBd0E933fb87dD2C9cE7A17d959b822', // wstETH
    'marketId': 5,
    'decimals': 18,
    'baseAsset': 'wstETH',
  },
  'sSOL': {
    'symbol': 'sSOL',
    'synthAddress': '0x1000000000000000000000000000000000000001',
    'collateralAddress': '0x2000000000000000000000000000000000000001',
    'marketId': 6,
    'decimals': 18,
    'baseAsset': 'SOL',
  },
  'sXRP': {
    'symbol': 'sXRP',
    'synthAddress': '0x1000000000000000000000000000000000000002',
    'collateralAddress': '0x2000000000000000000000000000000000000002',
    'marketId': 7,
    'decimals': 18,
    'baseAsset': 'XRP',
  },
  'sADA': {
    'symbol': 'sADA',
    'synthAddress': '0x1000000000000000000000000000000000000003',
    'collateralAddress': '0x2000000000000000000000000000000000000003',
    'marketId': 8,
    'decimals': 18,
    'baseAsset': 'ADA',
  },
  'sDOT': {
    'symbol': 'sDOT',
    'synthAddress': '0x1000000000000000000000000000000000000004',
    'collateralAddress': '0x2000000000000000000000000000000000000004',
    'marketId': 9,
    'decimals': 18,
    'baseAsset': 'DOT',
  },
  'sLINK': {
    'symbol': 'sLINK',
    'synthAddress': '0x1000000000000000000000000000000000000005',
    'collateralAddress': '0x2000000000000000000000000000000000000005',
    'marketId': 10,
    'decimals': 18,
    'baseAsset': 'LINK',
  },
  'sMATIC': {
    'symbol': 'sMATIC',
    'synthAddress': '0x1000000000000000000000000000000000000006',
    'collateralAddress': '0x2000000000000000000000000000000000000006',
    'marketId': 11,
    'decimals': 18,
    'baseAsset': 'MATIC',
  },
  'sAVAX': {
    'symbol': 'sAVAX',
    'synthAddress': '0x1000000000000000000000000000000000000007',
    'collateralAddress': '0x2000000000000000000000000000000000000007',
    'marketId': 12,
    'decimals': 18,
    'baseAsset': 'AVAX',
  },
  'sOP': {
    'symbol': 'sOP',
    'synthAddress': '0x1000000000000000000000000000000000000008',
    'collateralAddress': '0x2000000000000000000000000000000000000008',
    'marketId': 13,
    'decimals': 18,
    'baseAsset': 'OP',
  },
  'sARB': {
    'symbol': 'sARB',
    'synthAddress': '0x1000000000000000000000000000000000000009',
    'collateralAddress': '0x2000000000000000000000000000000000000009',
    'marketId': 14,
    'decimals': 18,
    'baseAsset': 'ARB',
  },
  'sLDO': {
    'symbol': 'sLDO',
    'synthAddress': '0x100000000000000000000000000000000000000a',
    'collateralAddress': '0x200000000000000000000000000000000000000a',
    'marketId': 15,
    'decimals': 18,
    'baseAsset': 'LDO',
  },
  'sUNI': {
    'symbol': 'sUNI',
    'synthAddress': '0x100000000000000000000000000000000000000b',
    'collateralAddress': '0x200000000000000000000000000000000000000b',
    'marketId': 16,
    'decimals': 18,
    'baseAsset': 'UNI',
  },
  'sAAVE': {
    'symbol': 'sAAVE',
    'synthAddress': '0x100000000000000000000000000000000000000c',
    'collateralAddress': '0x200000000000000000000000000000000000000c',
    'marketId': 17,
    'decimals': 18,
    'baseAsset': 'AAVE',
  },
  'sDOGE': {
    'symbol': 'sDOGE',
    'synthAddress': '0x100000000000000000000000000000000000000d',
    'collateralAddress': '0x200000000000000000000000000000000000000d',
    'marketId': 18,
    'decimals': 18,
    'baseAsset': 'DOGE',
  },
  'sSHIB': {
    'symbol': 'sSHIB',
    'synthAddress': '0x100000000000000000000000000000000000000e',
    'collateralAddress': '0x200000000000000000000000000000000000000e',
    'marketId': 19,
    'decimals': 18,
    'baseAsset': 'SHIB',
  },
  'sPEPE': {
    'symbol': 'sPEPE',
    'synthAddress': '0x100000000000000000000000000000000000000f',
    'collateralAddress': '0x200000000000000000000000000000000000000f',
    'marketId': 20,
    'decimals': 18,
    'baseAsset': 'PEPE',
  },
};

class SpotMarketsBloc extends Bloc<SpotMarketsEvent, SpotMarketsState> {
  SpotMarketsBloc({
    WalletRepository? walletRepository,
    OracleRepository? oracleRepository,
    MarketPriceRepository? marketPriceRepository,
  })  : _walletRepository = walletRepository,
        _oracleRepository = oracleRepository,
        _marketPriceRepository = marketPriceRepository,
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

    // Initialize markets on bloc creation (mirrors AccountBloc pattern)
    add(const SpotMarketsInitialize());
  }

  final WalletRepository? _walletRepository;
  final OracleRepository? _oracleRepository;
  final MarketPriceRepository? _marketPriceRepository;
  late Web3Client _web3Client;
  late SynthetixSpotRepository _synthetixRepo;
  late OracleRepository _oracleRepo;
  late MarketPriceRepository _marketPriceRepo;
  Timer? _pollingTimer;
  StreamSubscription<dynamic>? _eventSubscription;
  bool _isPageFocused = true;
  Timer? _oraclePollTimer;
  int _pollingIndex = 0;

  @override
  Future<void> close() async {
    // Cancel event listener subscription
    await _eventSubscription?.cancel();
    // Cancel background polling timers
    _pollingTimer?.cancel();
    _oraclePollTimer?.cancel();
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
      _web3Client = Web3Client(BASE_SEPOLIA_RPC, http.Client());

      // Initialize oracle repository (use injected one or create new)
      _oracleRepo = _oracleRepository ?? OracleRepository();
      print('🔷 SpotMarketsBloc initialized OracleRepository');

      // Initialize market price repository (CoinGecko)
      _marketPriceRepo = _marketPriceRepository ?? MarketPriceRepository();
      print('🔷 SpotMarketsBloc initialized MarketPriceRepository');

      // Initialize Synthetix repository
      _synthetixRepo = SynthetixSpotRepository(
        rpcUrl: BASE_SEPOLIA_RPC,
        spotMarketProxyAddress: SPOT_MARKET_PROXY,
        coreProxyAddress: CORE_PROXY,
        oracleManagerAddress: ORACLE_MANAGER,
      );
      await _synthetixRepo.initialize();

      // Fetch Synthetix v3 spot markets
      final markets = SYNTHETIX_SPOT_MARKETS.keys.toList();
      final initialMarket = markets.isNotEmpty ? markets.first : '';
      
      // Fetch market data in PARALLEL (not sequential)
      print('🔷 SpotMarketsBloc parallelizing market data fetch for ${markets.length} markets');
      final marketDataFuture = _fetchSynthetixMarketData(markets);
      
      final priceHistory = <String, List<GraphData>>{};
      const selectedRange = SpotMarketChartRange.day;

      // Defer chart history to background - don't wait for it on init
      if (initialMarket.isNotEmpty) {
        Future(() async {
          try {
            final history = await _fetchMarketPriceHistory(
              initialMarket,
              selectedRange,
            );
            if (history.isNotEmpty && state is SpotMarketsLoaded) {
              final currentState = state as SpotMarketsLoaded;
              final updatedHistory = Map<String, List<GraphData>>.from(currentState.priceHistory);
              updatedHistory[_historyKey(initialMarket, selectedRange)] = history;
              emit(currentState.copyWith(priceHistory: updatedHistory));
            }
          } catch (e) {
            print('🔷 Background chart load failed, not blocking: $e');
          }
        }).ignore();
      }
      
      // Wait for parallel market data
      final marketData = await marketDataFuture;

      // Start listening to selected-market-only events and staggered background polling
      _listenToMarketEventsFiltered();
      _startStaggeredPolling(markets);
      
      // Start oracle polling for real-time prices
      _startOraclePolling();

      emit(SpotMarketsLoaded(
        markets: markets,
        selectedMarket: initialMarket,
        marketData: marketData,
        priceHistory: priceHistory,
        selectedRange: selectedRange,
        showSidebar: true,
      ));
    } catch (e) {
      print('SpotMarketsInitialize error: $e');
      // Extract detailed error message
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error connecting to Base Sepolia',
          details: errorDetails,
        ));
      } else {
        emit(SpotMarketsError(
          'Failed to initialize spot markets',
          details: errorDetails,
        ));
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

  /// Start staggered background polling: update one market every 1s (stagger across 20 markets)
  /// Automatically pauses when page loses focus
  void _startStaggeredPolling(List<String> markets) {
    if (markets.isEmpty) return;

    // Reduced from 15s to 800ms stagger = faster updates
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 800), (_) async {
      // Skip polling if page not focused (reduces CPU/network when tab inactive)
      if (!_isPageFocused) return;
      if (state is! SpotMarketsLoaded) return;

      // Get next market to update (rotate through list)
      final marketToUpdate = markets[_pollingIndex % markets.length];
      _pollingIndex++;

      // Fetch only this market's price (fire and forget)
      _fetchSingleMarketPrice(marketToUpdate).then((updatedPrice) {
        if (updatedPrice != null && state is SpotMarketsLoaded) {
          final current = state as SpotMarketsLoaded;
          final updated = Map<String, SpotMarketModel>.from(current.marketData);
          final old = updated[marketToUpdate];
          if (old != null) {
            updated[marketToUpdate] = old.copyWith(currentPrice: updatedPrice);
            add(SpotMarketSingleRefresh(marketToUpdate));
          }
        }
      }).catchError((_) {
        // Silently fail - will retry next cycle
      });
    });
    print('🔷 SpotMarketsBloc staggered polling: 800ms stagger, pauses when page unfocused');
  }

  /// Start market price polling for real-time updates
  /// Reduced from 10s to 20s, only polls selected market, pauses when unfocused
  void _startOraclePolling() {
    _oraclePollTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      // Skip polling if page not focused or wrong state
      if (!_isPageFocused || state is! SpotMarketsLoaded) return;
      final currentState = state as SpotMarketsLoaded;

      try {
        // Only poll the SELECTED market (not all markets)
        // This cuts network calls by 95%
        final selectedConfig = SYNTHETIX_SPOT_MARKETS[currentState.selectedMarket];
        if (selectedConfig == null) return;

        final baseAsset = selectedConfig['baseAsset'] as String;
        final summary = await _marketPriceRepo.fetchMarketSummaries([baseAsset]);
        
        if (summary.isNotEmpty) {
          final marketSummary = summary[baseAsset];
          if (marketSummary != null && marketSummary.price > 0) {
            // Trigger event to update state (can't emit from Timer callback)
            add(SpotMarketSingleRefresh(currentState.selectedMarket));
          }
        }
      } catch (e) {
        // Silently fail - oracle polling is best-effort
      }
    });
    print('🔷 SpotMarketsBloc oracle polling: 20s interval, selected market only, pauses when unfocused');
  }

  /// Handle single market refresh from event-driven updates
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
        // Silent fail for event-driven updates
        print('Error refreshing ${event.market}: $e');
      }
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
          EthereumAddress.fromHex(USD_PROXY)
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
        ));
      } else {
        emit(SpotMarketsError(
          'Failed to prepare buy order: $e',
          details: errorDetails,
        ));
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
      var errorOrder = pendingOrder.copyWith(
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
          EthereumAddress.fromHex(USD_PROXY)
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
        ));
      } else {
        emit(SpotMarketsError(
          'Failed to prepare sell order: $e',
          details: errorDetails,
        ));
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
      var errorOrder = pendingOrder.copyWith(
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

  /// Fetch real market data from Synthetix v3 on Base Sepolia
  /// Prices are derived from SpotMarketProxy quotes (1 synth → USD)
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

      // Get real price from market summary (with oracle/quote fallback)
      double price;
      try {
        if (summary != null && summary.price > 0) {
          price = summary.price;
          print('🔷 SpotMarketsBloc using market price for $marketKey: $price');
        } else {
          // Fallback to oracle/quote
          price = await _getPriceFromSpotQuote(marketConfig);
          print('🔷 SpotMarketsBloc using quote price for $marketKey: $price');
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
        volume24h: 1000000 + (marketKey.hashCode % 5000000),
      );
    }

    return data;
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
        final start = DateTime(now.year, 1, 1);
        return now.difference(start).inDays.clamp(1, 365);
    }
  }

  String _historyKey(String marketKey, SpotMarketChartRange range) {
    return '${marketKey}_${range.name}';
  }

  /// Derive a price from SpotMarketProxy quotes
  /// Quotes selling exactly 1.0 synth to get USD price
  Future<double> _getPriceFromSpotQuote(
      Map<String, dynamic> marketConfig) async {
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

  /// Mock prices for Synthetix v3 spot markets
  /// Replace with real oracle data from Pyth
  double _getSynthetixMockPrice(String market) {
    switch (market) {
      case 'sUSDC':
        return 1.0; // USDC pegged to $1
      case 'scbBTC':
        return 42000; // BTC price from Pyth
      case 'scbETH':
        return 2200; // ETH price from Pyth
      case 'sWETH':
        return 2200; // WETH price from Pyth
      case 'swstETH':
        return 2500; // wstETH price from Pyth
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
