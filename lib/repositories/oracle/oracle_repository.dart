import 'package:ax_dapp/repositories/oracle/config/oracle_config.dart';
import 'package:ax_dapp/repositories/oracle/data/chainlink_oracle_client.dart';
import 'package:ax_dapp/repositories/oracle/data/custom_oracle_client.dart';
import 'package:ax_dapp/repositories/oracle/data/optimistic_zk_oracle_client.dart';
import 'package:ax_dapp/repositories/oracle/data/pyth_oracle_client.dart';
import 'package:ax_dapp/repositories/oracle/models/price_feed.dart';

/// Oracle repository with multi-source fallback
/// 
/// Provides unified interface to fetch prices from multiple oracle sources
/// with automatic fallback: Chainlink → Pyth → Custom
/// 
/// Features:
/// - Transparent fallback logic
/// - Price caching with staleness threshold
/// - Comprehensive error logging
/// - Resource cleanup on disposal
class OracleRepository {
  OracleRepository({
    String? chainlinkRpcUrl,
    String? pythApiUrl,
    String? customOracleBaseUrl,
    String? customOracleApiKey,
    String? optimisticZkOracleAddress,
    Duration? stalenessDuration,
  })  : _stalenessDuration = stalenessDuration ?? OracleConfig.priceStalenessDuration,
        _chainlinkClient = ChainlinkOracleClient(
          rpcUrl: chainlinkRpcUrl ?? OracleConfig.sepoliaRpcUrl,
        ),
        _pythClient = PythOracleClient(
          pythApiUrl: pythApiUrl ?? 'https://hermes.pyth.network',
        ),
        _optimisticZkClient = _createOptimisticZkClient(
          rpcUrl: chainlinkRpcUrl ?? OracleConfig.sepoliaRpcUrl,
          address: optimisticZkOracleAddress ??
              OracleConfig.optimisticZkOracleAddress,
        ),
        _customClient = customOracleBaseUrl != null
            ? CustomOracleClient(
                baseUrl: customOracleBaseUrl,
                apiKey: customOracleApiKey,
              )
            : null {
    print('📊 [OracleRepository] Initializing with fallback priority: '
        '${OracleConfig.fallbackPriority.map((s) => s.name).join(" → ")}');
  }

  /// In-memory price cache: symbol → PriceFeed
  final Map<String, PriceFeed> _priceCache = {};

  /// Staleness threshold for cached prices
  final Duration _stalenessDuration;

  /// Oracle clients
  final ChainlinkOracleClient _chainlinkClient;
  final PythOracleClient _pythClient;
  final OptimisticZkOracleClient? _optimisticZkClient;
  final CustomOracleClient? _customClient;

  static OptimisticZkOracleClient? _createOptimisticZkClient({
    required String rpcUrl,
    required String? address,
  }) {
    if (address == null || address.trim().isEmpty) {
      return null;
    }

    return OptimisticZkOracleClient(
      rpcUrl: rpcUrl,
      contractAddress: address,
    );
  }

  /// Get price for a single symbol with automatic fallback
  /// 
  /// Parameters:
  ///   - symbol: Asset symbol (e.g., 'ETH', 'BTC', 'USDC')
  ///   - forceRefresh: If true, ignore cache and fetch fresh data
  /// 
  /// Returns: PriceFeed with price from first available source
  /// 
  /// Strategy:
  /// 1. Check cache if fresh and not force-refreshing
  /// 2. Try Chainlink
  /// 3. On failure, try Pyth
  /// 4. On failure, try Custom
  /// 5. On failure, return cached stale price if available
  /// 6. On complete failure, throw exception
  /// 
  /// Throws: Exception if all sources fail and no cache exists
  Future<PriceFeed> getPrice(String symbol, {bool forceRefresh = false}) async {
    print('📊 [OracleRepository] Getting price for $symbol (forceRefresh: $forceRefresh)');

    // Check cache first (if not force-refreshing and price is fresh)
    if (!forceRefresh && _priceCache.containsKey(symbol)) {
      final cached = _priceCache[symbol]!;
      if (cached.isFresh(_stalenessDuration)) {
        print('📊 [OracleRepository] ✓ Using cached price for $symbol '
            '(age: ${cached.ageSeconds}s)');
        return cached;
      } else {
        print('📊 [OracleRepository] Cached price for $symbol is stale '
            '(age: ${cached.ageSeconds}s)');
      }
    }

    // Try fallback chain: Chainlink → Pyth → Custom
    for (final source in OracleConfig.fallbackPriority) {
      try {
        PriceFeed? result;

        switch (source) {
          case OracleSource.chainlink:
            result = await _tryChainlink(symbol);
            break;
          case OracleSource.pyth:
            result = await _tryPyth(symbol);
            break;
          case OracleSource.optimisticZk:
            result = await _tryOptimisticZk(symbol);
            break;
          case OracleSource.custom:
            result = await _tryCustom(symbol);
            break;
        }

        if (result != null) {
          // Cache successful result
          _priceCache[symbol] = result;
          print('📊 [OracleRepository] ✓ Fetched $symbol from ${source.name}');
          return result;
        }
      } catch (e) {
        print('📊 [OracleRepository] ⚠️ Failed to fetch from ${source.name}: $e');
        continue; // Try next source
      }
    }

    // All sources failed, try to return stale cache
    if (_priceCache.containsKey(symbol)) {
      final stale = _priceCache[symbol]!;
      print('📊 [OracleRepository] ⚠️ All sources failed, returning stale '
          'price for $symbol (age: ${stale.ageSeconds}s)');
      return stale;
    }

    // Complete failure
    throw Exception(
      '📊 [OracleRepository] Failed to fetch price for $symbol from all sources',
    );
  }

  /// Get prices for multiple symbols in parallel
  /// 
  /// Returns: Map of symbol → PriceFeed
  /// Individual symbol failures won't block other requests
  Future<Map<String, PriceFeed>> getPrices(
    List<String> symbols, {
    bool forceRefresh = false,
  }) async {
    print('📊 [OracleRepository] Getting prices for ${symbols.length} symbols');

    final priceMap = <String, PriceFeed>{};

    for (final symbol in symbols) {
      try {
        final price = await getPrice(symbol, forceRefresh: forceRefresh);
        priceMap[symbol] = price;
      } catch (e) {
        print('📊 [OracleRepository] Error fetching $symbol: $e');
        // Continue to next symbol
      }
    }

    print('📊 [OracleRepository] Successfully fetched ${priceMap.length}/${symbols.length} prices');
    return priceMap;
  }

  /// Try to fetch price from Chainlink
  Future<PriceFeed?> _tryChainlink(String symbol) async {
    final address = OracleConfig.chainlinkFeeds[symbol];
    if (address == null) {
      print('📊 [OracleRepository] No Chainlink feed configured for $symbol');
      return null;
    }

    try {
      print('📊 [OracleRepository] Trying Chainlink for $symbol...');
      final price = await _chainlinkClient.getLatestPrice(symbol, address);
      print('📊 [OracleRepository] ✓ Chainlink returned $symbol: ${price.price}');
      return price;
    } catch (e) {
      print('📊 [OracleRepository] Chainlink failed for $symbol: $e');
      rethrow;
    }
  }

  /// Try to fetch price from Pyth
  Future<PriceFeed?> _tryPyth(String symbol) async {
    final feedId = OracleConfig.pythFeedIds[symbol];
    if (feedId == null) {
      print('📊 [OracleRepository] No Pyth feed configured for $symbol');
      return null;
    }

    try {
      print('📊 [OracleRepository] Trying Pyth for $symbol...');
      final price = await _pythClient.getLatestPrice(symbol, feedId);
      print('📊 [OracleRepository] ✓ Pyth returned $symbol: ${price.price}');
      return price;
    } catch (e) {
      print('📊 [OracleRepository] Pyth failed for $symbol: $e');
      rethrow;
    }
  }

  /// Try to fetch price from Custom oracle
  Future<PriceFeed?> _tryCustom(String symbol) async {
    if (_customClient == null) {
      print('📊 [OracleRepository] No Custom oracle configured');
      return null;
    }

    try {
      print('📊 [OracleRepository] Trying Custom oracle for $symbol...');
      final price = await _customClient!.getLatestPrice(symbol);
      print('📊 [OracleRepository] ✓ Custom oracle returned $symbol: ${price.price}');
      return price;
    } catch (e) {
      print('📊 [OracleRepository] Custom oracle failed for $symbol: $e');
      rethrow;
    }
  }

  /// Try to fetch price from Optimistic ZK oracle
  Future<PriceFeed?> _tryOptimisticZk(String symbol) async {
    if (_optimisticZkClient == null) {
      print('📊 [OracleRepository] No Optimistic ZK oracle configured');
      return null;
    }

    try {
      print('📊 [OracleRepository] Trying Optimistic ZK oracle for $symbol...');
      final price = await _optimisticZkClient!.getLatestPrice(symbol);
      print('📊 [OracleRepository] ✓ Optimistic ZK oracle returned $symbol: ${price.price}');
      return price;
    } catch (e) {
      print('📊 [OracleRepository] Optimistic ZK oracle failed for $symbol: $e');
      rethrow;
    }
  }

  /// Clear the price cache
  void clearCache() {
    print('📊 [OracleRepository] Clearing price cache (${_priceCache.length} entries)');
    _priceCache.clear();
  }

  /// Clear stale prices from cache
  /// 
  /// Returns: Number of entries removed
  int clearStaleCache() {
    final keys = _priceCache.keys.toList();
    var removedCount = 0;

    for (final symbol in keys) {
      final price = _priceCache[symbol]!;
      if (!price.isFresh(_stalenessDuration)) {
        _priceCache.remove(symbol);
        removedCount++;
      }
    }

    print('📊 [OracleRepository] Cleared $removedCount stale cache entries');
    return removedCount;
  }

  /// Get cache statistics
  String getCacheStats() {
    final total = _priceCache.length;
    var fresh = 0;
    var stale = 0;

    for (final price in _priceCache.values) {
      if (price.isFresh(_stalenessDuration)) {
        fresh++;
      } else {
        stale++;
      }
    }

    return 'Cache: $total entries ($fresh fresh, $stale stale)';
  }

  /// Cleanup resources
  Future<void> dispose() async {
    print('📊 [OracleRepository] Disposing resources');
    _priceCache.clear();
    _chainlinkClient.dispose();
    _pythClient.dispose();
    _optimisticZkClient?.dispose();
    _customClient?.dispose();
  }
}
