import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/repositories/oracle/oracle_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Portfolio balance calculation service
/// 
/// Fetches wallet token balances and queries prices from oracle repository
/// with 8-minute TTL caching. Multiplies balance * price for total USD value.
/// 
/// Supports:
/// - Primary collateral (AX) via balance queries
/// - Multi-token portfolio aggregation
/// - Cache invalidation on wallet/chain changes
/// - Fallback to oracle repository (Synthetix → Chainlink → Pyth → Custom)
class PortfolioBalanceService {
  PortfolioBalanceService({
    required WalletRepository walletRepository,
    required OracleRepository oracleRepository,
    Duration cacheTtl = const Duration(minutes: 8),
  })  : _walletRepository = walletRepository,
        _oracleRepository = oracleRepository,
        _cacheTtl = cacheTtl;

  final WalletRepository _walletRepository;
  final OracleRepository _oracleRepository;
  final Duration _cacheTtl;

  /// Cached portfolio balance: {tokenSymbol: usdValue}
  final Map<String, double> _balanceCache = {};

  /// Last fetch timestamp per token
  final Map<String, DateTime> _lastFetchTime = {};

  /// Total portfolio USD value (cached)
  double? _cachedTotalUsd;
  DateTime? _lastTotalFetchTime;

  /// Check if cached balance is still fresh
  bool _isCacheFresh(String symbol) {
    if (!_lastFetchTime.containsKey(symbol)) return false;
    final elapsed = DateTime.now().difference(_lastFetchTime[symbol]!);
    return elapsed < _cacheTtl;
  }

  /// Check if total balance cache is still fresh
  bool _isTotalCacheFresh() {
    if (_lastTotalFetchTime == null) return false;
    final elapsed = DateTime.now().difference(_lastTotalFetchTime!);
    return elapsed < _cacheTtl;
  }

  /// Invalidate all cached balances
  void invalidateCache() {
    _balanceCache.clear();
    _lastFetchTime.clear();
    _cachedTotalUsd = null;
    _lastTotalFetchTime = null;
    debugPrint('📊 [PortfolioBalanceService] Cache invalidated');
  }

  /// Get single token balance in USD (balance * price)
  /// 
  /// Parameters:
  ///   - symbol: Token symbol (e.g., 'AX', 'USDC', 'WETH')
  ///   - decimals: Token decimals (18 for AX, 6 for USDC)
  ///   - forceRefresh: If true, ignore cache and fetch fresh
  /// 
  /// Returns: USD value of token balance, or 0.0 if balance is 0 or unavailable
  Future<double> getTokenBalanceUsd(
    String symbol, {
    int decimals = 18,
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first
      if (!forceRefresh && _isCacheFresh(symbol)) {
        debugPrint('📊 [PortfolioBalanceService] Using cached balance for $symbol: \$${_balanceCache[symbol]!.toStringAsFixed(2)}');
        return _balanceCache[symbol] ?? 0.0;
      }

      // Get wallet balance (raw balance in token units)
      final balance = await _walletRepository.getTokenBalance(symbol);
      if (balance == null || balance == 0.0) {
        _balanceCache[symbol] = 0.0;
        _lastFetchTime[symbol] = DateTime.now();
        return 0.0;
      }

      // Get price from oracle repository (multi-source fallback)
      final priceFeed = await _oracleRepository.getPrice(symbol, forceRefresh: forceRefresh);
      final price = priceFeed.price;

      // Calculate USD value: balance * price
      final usdValue = balance * price;

      // Update cache
      _balanceCache[symbol] = usdValue;
      _lastFetchTime[symbol] = DateTime.now();

      debugPrint('📊 [PortfolioBalanceService] $symbol: balance=$balance, price=\$$price, USD=\$${usdValue.toStringAsFixed(2)}');

      return usdValue;
    } catch (e) {
      debugPrint('❌ [PortfolioBalanceService] Error calculating $symbol balance: $e');
      // Return cached value if available, otherwise 0
      return _balanceCache[symbol] ?? 0.0;
    }
  }

  /// Get total portfolio USD value
  /// 
  /// Aggregates balance USD for primary collateral (AX) and USDC
  /// Returns: Total USD value, 0.0 if all queries fail
  Future<double> getTotalPortfolioUsd({
    bool forceRefresh = false,
  }) async {
    try {
      // Check cache first
      if (!forceRefresh && _isTotalCacheFresh()) {
        debugPrint('📊 [PortfolioBalanceService] Using cached total portfolio: \$${_cachedTotalUsd!.toStringAsFixed(2)}');
        return _cachedTotalUsd ?? 0.0;
      }

      // Get AX balance
      final axUsd = await getTokenBalanceUsd(
        AthleteXSynthetixConfig.primaryCollateralSymbol,
        forceRefresh: forceRefresh,
      );

      // Get USDC balance (stablecoin, 1:1 with USD)
      final usdcUsd = await getTokenBalanceUsd('USDC', decimals: 6, forceRefresh: forceRefresh);

      // Total portfolio
      final total = axUsd + usdcUsd;

      // Update cache
      _cachedTotalUsd = total;
      _lastTotalFetchTime = DateTime.now();

      debugPrint('📊 [PortfolioBalanceService] Total portfolio: AX=\$${axUsd.toStringAsFixed(2)} + USDC=\$${usdcUsd.toStringAsFixed(2)} = \$${total.toStringAsFixed(2)}');

      return total;
    } catch (e) {
      debugPrint('❌ [PortfolioBalanceService] Error calculating total portfolio: $e');
      return _cachedTotalUsd ?? 0.0;
    }
  }

  /// Dispose of resources
  void dispose() {
    _balanceCache.clear();
    _lastFetchTime.clear();
    debugPrint('📊 [PortfolioBalanceService] Disposed');
  }
}
