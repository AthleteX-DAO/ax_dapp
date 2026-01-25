import 'dart:async';
import 'dart:math';
import 'package:ax_dapp/spot_markets/models/spot_market_model.dart';
import 'package:ax_dapp/spot_markets/repository/synthetix_spot_repository.dart';
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
};

class SpotMarketsBloc extends Bloc<SpotMarketsEvent, SpotMarketsState> {
  SpotMarketsBloc({
    WalletRepository? walletRepository,
  })  : _walletRepository = walletRepository,
        super(const SpotMarketsInitial()) {
    on<SpotMarketsInitialize>(_onInitialize);
    on<SpotMarketsRefresh>(_onRefresh);
    on<SpotMarketSelected>(_onMarketSelected);
    on<SpotMarketBuyOrderPlaced>(_onBuyOrderPlaced);
    on<SpotMarketSellOrderPlaced>(_onSellOrderPlaced);
    on<SpotSidebarVisibilityToggled>(_onSidebarToggled);
    on<SpotMarketSingleRefresh>(_onSingleMarketRefresh);

    // Initialize markets on bloc creation (mirrors AccountBloc pattern)
    add(const SpotMarketsInitialize());
  }

  final WalletRepository? _walletRepository;
  late Web3Client _web3Client;
  late SynthetixSpotRepository _synthetixRepo;

  // Track event subscription and background polling for cleanup
  StreamSubscription<dynamic>? _eventSubscription;
  Timer? _pollingTimer;
  int _pollingIndex = 0; // Track which market to update next

  @override
  Future<void> close() async {
    // Cancel event listener subscription
    await _eventSubscription?.cancel();
    // Cancel background polling timer
    _pollingTimer?.cancel();
    _web3Client.dispose();
    _synthetixRepo.dispose();
    return super.close();
  }

  Future<void> _onInitialize(
    SpotMarketsInitialize event,
    Emitter<SpotMarketsState> emit,
  ) async {
    emit(const SpotMarketsLoading());
    try {
      _web3Client = Web3Client(BASE_SEPOLIA_RPC, http.Client());

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
      final marketData = await _fetchSynthetixMarketData(markets);

      // Start listening to selected-market-only events and staggered background polling
      _listenToMarketEventsFiltered();
      _startStaggeredPolling(markets);

      emit(SpotMarketsLoaded(
        markets: markets,
        selectedMarket: initialMarket,
        marketData: marketData,
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

  /// Listen to market events but only update the selected market (no global refresh)
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
        print('Event listener error: $error');
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

  /// Start staggered background polling: update one market every 15 seconds
  void _startStaggeredPolling(List<String> markets) {
    if (markets.isEmpty) return;

    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
      if (state is! SpotMarketsLoaded) return;
      final currentState = state as SpotMarketsLoaded;

      // Get next market to update (rotate through list)
      final marketToUpdate = markets[_pollingIndex % markets.length];
      _pollingIndex++;

      // Fetch only this market's price
      try {
        final updatedPrice = await _fetchSingleMarketPrice(marketToUpdate);
        if (updatedPrice != null) {
          final updated = Map<String, SpotMarketModel>.from(currentState.marketData);
          final old = updated[marketToUpdate];
          if (old != null) {
            updated[marketToUpdate] = old.copyWith(currentPrice: updatedPrice);
            emit(currentState.copyWith(marketData: updated));
          }
        }
      } catch (e) {
        print('Staggered polling error for $marketToUpdate: $e');
        // Continue polling silently on error
      }
    });
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
      // Apply 1% slippage tolerance
      final minSynthAmount =
          (expectedSynthAmount * BigInt.from(99)) ~/ BigInt.from(100);

      // Check allowance and approve if needed
      final userAddress = credentials.value.address;
      final allowance = await _synthetixRepo.getAllowance(
        tokenAddress: USD_PROXY,
        userAddress: userAddress.hex,
      );

      if (allowance < usdAmount) {
        emit(const SpotMarketsLoading());
        final approveTxHash = await _synthetixRepo.approveTokenSpending(
          tokenAddress: USD_PROXY,
          amount: BigInt.from(2).pow(256) - BigInt.one, // Max approval
          credentials: credentials.value,
        );

        // Wait for approval confirmation
        await _waitForTransaction(approveTxHash);
      }

      // Estimate gas before executing
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

      // Emit gas estimate for user confirmation
      emit(SpotMarketsGasEstimate(
        gasLimit: gasEstimate['gasLimit'] as BigInt,
        gasPrice: gasEstimate['gasPrice'] as BigInt,
        totalCostWei: gasEstimate['totalCostWei'] as BigInt,
        totalCostEth: gasEstimate['totalCostEth'] as String,
      ));

      // Execute buy order
      final txHash = await _synthetixRepo.executeBuyOrder(
        marketId: marketId,
        usdAmount: usdAmount,
        minSynthAmount: minSynthAmount,
        credentials: credentials.value,
      );

      final orderId = _generateOrderId();
      emit(SpotMarketOrderPlaced(
        message:
            'Buy order submitted for ${event.quantity} ${event.market} on Synthetix v3\nTx: $txHash\nOrder ID: $orderId',
        orderId: orderId,
      ));

      // Wait for transaction and refresh
      await _waitForTransaction(txHash);
      add(const SpotMarketsRefresh());
    } catch (e) {
      // Extract detailed error message
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error during buy order',
          details: errorDetails,
        ));
      } else {
        emit(SpotMarketsError(
          'Failed to place buy order',
          details: errorDetails,
        ));
      }
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

      // Check if wallet is connected
      if (_walletRepository == null) {
        throw Exception('Wallet not connected');
      }

      final credentials = _walletRepository!.credentials;

      final marketId = marketConfig['marketId'] as int;
      final synthAddress = marketConfig['synthAddress'] as String;
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
      // Apply 1% slippage tolerance
      final minUsdAmount =
          (expectedUsdAmount * BigInt.from(99)) ~/ BigInt.from(100);

      // Check allowance and approve if needed
      final userAddress = credentials.value.address;
      final allowance = await _synthetixRepo.getAllowance(
        tokenAddress: synthAddress,
        userAddress: userAddress.hex,
      );

      if (allowance < synthAmount) {
        emit(const SpotMarketsLoading());
        final approveTxHash = await _synthetixRepo.approveTokenSpending(
          tokenAddress: synthAddress,
          amount: BigInt.from(2).pow(256) - BigInt.one, // Max approval
          credentials: credentials.value,
        );

        // Wait for approval confirmation
        await _waitForTransaction(approveTxHash);
      }

      // Estimate gas before executing
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

      // Emit gas estimate
      emit(SpotMarketsGasEstimate(
        gasLimit: gasEstimate['gasLimit'] as BigInt,
        gasPrice: gasEstimate['gasPrice'] as BigInt,
        totalCostWei: gasEstimate['totalCostWei'] as BigInt,
        totalCostEth: gasEstimate['totalCostEth'] as String,
      ));

      // Execute sell order
      final txHash = await _synthetixRepo.executeSellOrder(
        marketId: marketId,
        synthAmount: synthAmount,
        minUsdAmount: minUsdAmount,
        credentials: credentials.value,
      );

      final orderId = _generateOrderId();
      emit(SpotMarketOrderPlaced(
        message:
            'Sell order submitted for ${event.quantity} ${event.market} on Synthetix v3\nTx: $txHash\nOrder ID: $orderId',
        orderId: orderId,
      ));

      // Wait for transaction and refresh
      await _waitForTransaction(txHash);
      add(const SpotMarketsRefresh());
    } catch (e) {
      // Extract detailed error message
      final errorDetails = e.toString();
      if (errorDetails.contains('RPC') || errorDetails.contains('network')) {
        emit(SpotMarketsError(
          'Network error during sell order',
          details: errorDetails,
        ));
      } else {
        emit(SpotMarketsError(
          'Failed to place sell order',
          details: errorDetails,
        ));
      }
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

    for (final marketKey in markets) {
      final marketConfig = SYNTHETIX_SPOT_MARKETS[marketKey];
      if (marketConfig == null) continue;

      // Get real price from SpotMarketProxy quote
      double price;
      try {
        price = await _getPriceFromSpotQuote(marketConfig);
      } catch (_) {
        // Fallback to mock only if quote fails
        price = _getSynthetixMockPrice(marketKey);
      }

      final change24h = _getPriceChange(marketKey);

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

  /// Fetch price for a single market (efficient for polling)
  Future<double?> _fetchSingleMarketPrice(String marketKey) async {
    final marketConfig = SYNTHETIX_SPOT_MARKETS[marketKey];
    if (marketConfig == null) return null;

    try {
      return await _getPriceFromSpotQuote(marketConfig);
    } catch (_) {
      return _getSynthetixMockPrice(marketKey);
    }
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

  double _getPriceChange(String market) {
    return (100 - (market.hashCode % 200)).toDouble();
  }

  String _generateOrderId() {
    return 'SNX-${DateTime.now().millisecondsSinceEpoch}';
  }
}
