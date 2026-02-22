import 'dart:async';

import 'package:ax_dapp/account/models/account_models.dart';
import 'package:ax_dapp/config/athletex_synthetix_config.dart';
import 'package:ax_dapp/account/repository/synthetix_batch_queries.dart';
import 'package:ax_dapp/service/synthetix_core_service.dart';
import 'package:ax_dapp/service/controller/earn/vault_repository.dart';
import 'package:ethereum_api/erc20_api.dart' as erc20_api;
import 'package:web3dart/web3dart.dart';
import 'package:rxdart/rxdart.dart';

/// Watches and monitors Synthetix account state in real-time
/// Polls account data periodically and emits updates via streams
/// Integrates with cache to reduce RPC calls
class SynthetixDataWatcher {
  SynthetixDataWatcher({
    required SynthetixCoreService synthetixCoreService,
    required SynthetixAccountCache cache,
    VaultRepository? vaultRepository,
  })  : _cache = cache,
        _vaultRepository = vaultRepository,
        _client = synthetixCoreService.client,
        _batchQueries = SynthetixBatchQueries(
          client: synthetixCoreService.client,
        );

  final SynthetixAccountCache _cache;
  final SynthetixBatchQueries _batchQueries;
  final VaultRepository? _vaultRepository;
  final Web3Client _client;

  /// Stream of account updates (emits when account state changes)
  final _accountStream = BehaviorSubject<SynthetixAccount?>();
  Stream<SynthetixAccount?> get accountStream => _accountStream.stream;

  /// Stream of collateral updates (emits when collateral changes)
  final _collateralStream =
      BehaviorSubject<Map<String, SynthetixCollateral>>()
        ..add({});
  Stream<Map<String, SynthetixCollateral>> get collateralStream =>
      _collateralStream.stream;

  /// Stream of position updates (emits when positions change)
  final _positionsStream = BehaviorSubject<Map<int, ProtocolPosition>>()
    ..add({});
  Stream<Map<int, ProtocolPosition>> get positionsStream =>
      _positionsStream.stream;

  /// Stream of error states
  final _errorStream = BehaviorSubject<String?>();
  Stream<String?> get errorStream => _errorStream.stream;

  /// Stream of loading state
  final _loadingStream = BehaviorSubject<bool>();
  Stream<bool> get loadingStream => _loadingStream.stream;

  // Polling and lifecycle management
  Timer? _pollingTimer;
  bool _isWatching = false;
  String? _currentWalletAddress;
  int? _currentAccountId;
  _VaultConfig? _cachedVaultConfig;

  /// Start watching a specific Synthetix account
  Future<void> startWatching({
    required String walletAddress,
    required int synthetixAccountId,
  }) async {
    if (_isWatching &&
        _currentWalletAddress == walletAddress &&
        _currentAccountId == synthetixAccountId) {
      // Already watching this account
      return;
    }

    await stopWatching();

    _currentWalletAddress = walletAddress;
    _currentAccountId = synthetixAccountId;
    _isWatching = true;

    // Initial fetch
    await _fetchAccountData();

    // Start polling
    _pollingTimer = Timer.periodic(
      AthleteXSynthetixConfig.accountPollingInterval,
      (_) => _fetchAccountData(),
    );
  }

  /// Stop watching the current account
  Future<void> stopWatching() async {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _isWatching = false;
    _currentWalletAddress = null;
    _currentAccountId = null;
    _errorStream.add(null); // Clear errors
    _loadingStream.add(false);
  }

  /// Force a refresh of account data (immediate, outside normal polling)
  Future<void> refresh() async {
    if (!_isWatching) return;
    await _fetchAccountData();
  }

  /// Internal: Fetch account data from blockchain or cache
  Future<void> _fetchAccountData() async {
    if (_currentWalletAddress == null || _currentAccountId == null) {
      return;
    }

    try {
      _errorStream.add(null); // Clear previous errors

      final cacheKey =
          '${_currentWalletAddress}_${_currentAccountId}_synthetix_account';

      // Try cache first
      final cached = await _cache.getAccount(cacheKey);
      if (cached != null) {
        _accountStream.add(cached);
        _collateralStream.add(cached.collaterals);
        _positionsStream.add(cached.positions);
        _loadingStream.add(false);

        // In background, fetch fresh data for next iteration
        _fetchFreshAccountData(cacheKey);
        return;
      }

      // No cache, fetch fresh
      await _fetchFreshAccountData(cacheKey);
    } catch (e) {
      _loadingStream.add(false);
      _errorStream.add('Failed to fetch account data: ${e}');
    }
  }

  /// Fetch fresh data from blockchain
  Future<void> _fetchFreshAccountData(String cacheKey) async {
    try {
      _loadingStream.add(true);

      final vaultConfig = await _resolveVaultConfig();

      if (vaultConfig == null) {
        throw Exception('Vault configuration not available');
      }

      // Batch-fetch collateral, available, debt, and c-ratio via Multicall3
      final snapshot = await _batchQueries.fetchAccountSnapshot(
        accountId: _currentAccountId!,
        collateralAddress: vaultConfig.collateralAddress,
        poolId: vaultConfig.poolId,
      );

      // Convert c-ratio from 18 decimals to percentage
        final cRatio = snapshot.collateralRatio == BigInt.zero
          ? 0.0
          : snapshot.collateralRatio.toDouble() / 1e18;

      // Build collateral object
      final deposited = snapshot.deposited;
      final availableCollateral = snapshot.available;
      final locked = (deposited - availableCollateral).abs();

      final synthetixCollateral = SynthetixCollateral(
        tokenAddress: vaultConfig.collateralAddress,
        tokenSymbol: vaultConfig.symbol,
        tokenDecimals: vaultConfig.decimals,
        depositedAmount: deposited,
        availableAmount: availableCollateral,
        lockedAmount: locked,
        depositedInUsd: _toDecimal(deposited, vaultConfig.decimals) *
            0.0, // TODO: Replace with Pyth oracle price feed once integrated
      );

      // Build position object
      final position = ProtocolPosition(
        poolId: vaultConfig.poolId,
        poolName: vaultConfig.poolName,
        collateralAddress: vaultConfig.collateralAddress,
        debt: snapshot.debt,
        debtInUsd: _toDecimal(snapshot.debt, vaultConfig.decimals) *
            0.0, // TODO: Replace with Pyth oracle price feed once integrated
        collateralizationRatio: cRatio,
        isLiquidatable: cRatio <
            AthleteXSynthetixConfig.minSafeCollateralizationRatio,
        unrealizedPnl: BigInt.zero, // TODO: Calculate from position
        unrealizedPnlInUsd: 0, // TODO: Calculate from position
      );

      // Build complete account object
      final account = SynthetixAccount(
        accountId: _currentAccountId!,
        ownerAddress: _currentWalletAddress!,
        collaterals: {
          vaultConfig.collateralAddress: synthetixCollateral,
        },
        positions: {vaultConfig.poolId: position},
        totalCollateralInUsd: synthetixCollateral.depositedInUsd,
        totalDebtInUsd: position.debtInUsd,
        overallCollateralizationRatio: cRatio,
        createdAtBlock: 0, // TODO: Track creation block
      );

      // Cache the result
      await _cache.saveAccount(cacheKey, account);

      // Emit updates
      _accountStream.add(account);
      _collateralStream.add(account.collaterals);
      _positionsStream.add(account.positions);
      _errorStream.add(null);
      _loadingStream.add(false);
    } catch (e) {
      _loadingStream.add(false);
      _errorStream.add('RPC Error: ${e}');
      rethrow;
    }
  }

  /// Get current cached account value
  SynthetixAccount? get currentAccount => _accountStream.valueOrNull;

  /// Get current cached collaterals
  Map<String, SynthetixCollateral> get currentCollaterals =>
      _collateralStream.value;

  /// Get current cached positions
  Map<int, ProtocolPosition> get currentPositions => _positionsStream.value;

  /// Check if currently watching
  bool get isWatching => _isWatching;

  /// Cleanup: dispose all streams and timers
  Future<void> dispose() async {
    await stopWatching();
    await _accountStream.close();
    await _collateralStream.close();
    await _positionsStream.close();
    await _errorStream.close();
    await _loadingStream.close();
  }

  Future<_VaultConfig?> _resolveVaultConfig() async {
    if (_cachedVaultConfig != null) {
      return _cachedVaultConfig;
    }

    if (_vaultRepository == null) {
      final fallback = AthleteXSynthetixConfig.getCollateralInfo(
        AthleteXSynthetixConfig.primaryCollateralAddress,
      );
      if (fallback == null) return null;
      _cachedVaultConfig = _VaultConfig(
        poolId: AthleteXSynthetixConfig.defaultPoolId,
        poolName: AthleteXSynthetixConfig.defaultPoolName,
        collateralAddress: fallback.address,
        symbol: fallback.symbol,
        decimals: fallback.decimals,
      );
      return _cachedVaultConfig;
    }

    final vaults = await _vaultRepository!.fetchVaults();
    if (vaults.isEmpty) return null;

    final primary = vaults.first;
    final decimals = await _getTokenDecimals(primary.collateralAddress);

    _cachedVaultConfig = _VaultConfig(
      poolId: primary.poolId.toInt(),
      poolName: primary.symbol == 'USDC'
          ? AthleteXSynthetixConfig.defaultPoolName
          : primary.symbol,
      collateralAddress: primary.collateralAddress,
      symbol: primary.symbol,
      decimals: decimals,
    );
    return _cachedVaultConfig;
  }

  Future<int> _getTokenDecimals(String tokenAddress) async {
    final token = erc20_api.ERC20(
      address: EthereumAddress.fromHex(tokenAddress),
      client: _client,
    );
    final decimals = await token.decimals();
    return decimals.toInt();
  }

  double _toDecimal(BigInt amount, int decimals) {
    final divisor = BigInt.from(10).pow(decimals);
    return amount.toDouble() / divisor.toDouble();
  }
}

class _VaultConfig {
  const _VaultConfig({
    required this.poolId,
    required this.poolName,
    required this.collateralAddress,
    required this.symbol,
    required this.decimals,
  });

  final int poolId;
  final String poolName;
  final String collateralAddress;
  final String symbol;
  final int decimals;
}

/// Simple in-memory cache with TTL for Synthetix account data
class SynthetixAccountCache {
  final Map<String, _CacheEntry<SynthetixAccount>> _cache = {};

  /// Save account to cache
  Future<void> saveAccount(String key, SynthetixAccount account) async {
    _cache[key] = _CacheEntry(
      data: account,
      expiresAt: DateTime.now().add(AthleteXSynthetixConfig.cacheTTL),
    );
  }

  /// Get account from cache (returns null if expired or not found)
  Future<SynthetixAccount?> getAccount(String key) async {
    final entry = _cache[key];
    if (entry == null) return null;

    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cache.remove(key);
      return null;
    }

    return entry.data;
  }

  /// Clear all cache
  Future<void> clear() async {
    _cache.clear();
  }

  /// Clear specific key
  Future<void> remove(String key) async {
    _cache.remove(key);
  }
}

/// Internal cache entry with TTL
class _CacheEntry<T> {
  _CacheEntry({
    required this.data,
    required this.expiresAt,
  });

  final T data;
  final DateTime expiresAt;
}
