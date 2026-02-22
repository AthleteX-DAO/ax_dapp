import 'dart:math' as math;

import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ethereum_api/erc20_api.dart' as erc20_api;
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/synthetix_v3_api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/web3dart.dart' as web3;

/// Data class for vault information.
class VaultData {
  const VaultData({
    required this.symbol,
    required this.balance,
    required this.tvl,
    required this.apy,
    required this.vaultAddress,
    required this.collateralAddress,
    required this.poolId,
    required this.timestamp,
  });

  /// Vault symbol (e.g., 'WBTC', 'WETH').
  final String symbol;

  /// User's balance in the vault.
  final double balance;

  /// Total value locked in the vault.
  final double tvl;

  /// Annual percentage yield.
  final double apy;

  /// The vault contract address (CoreProxy).
  final String vaultAddress;

  /// The collateral token address (WBTC/WETH).
  final String collateralAddress;

  /// The pool ID for this vault.
  final BigInt poolId;

  /// Last update timestamp.
  final DateTime timestamp;

  VaultData copyWith({
    String? symbol,
    double? balance,
    double? tvl,
    double? apy,
    String? vaultAddress,
    String? collateralAddress,
    BigInt? poolId,
    DateTime? timestamp,
  }) {
    return VaultData(
      symbol: symbol ?? this.symbol,
      balance: balance ?? this.balance,
      tvl: tvl ?? this.tvl,
      apy: apy ?? this.apy,
      vaultAddress: vaultAddress ?? this.vaultAddress,
      collateralAddress: collateralAddress ?? this.collateralAddress,
      poolId: poolId ?? this.poolId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'VaultData(symbol: $symbol, balance: $balance, tvl: $tvl, apy: $apy, poolId: $poolId)';
}

/// Repository for managing Synthetix V3 vault operations.
class VaultRepository {
  VaultRepository({
    required EthereumChain chain,
    required ValueStream<Web3Client> reactiveWeb3Client,
    required WalletRepository walletRepository,
    this.userAddress,
    BigInt? accountId,
  })  : _chain = chain,
        _reactiveWeb3Client = reactiveWeb3Client,
        _walletRepository = walletRepository,
        accountId = accountId ?? BigInt.from(1);

  /// The Ethereum chain for vault operations. Mutable — updated on chain switch.
  EthereumChain get chain => _chain;
  EthereumChain _chain;

  /// Update the active chain. Called by EarnPageBloc when AppData changes.
  void updateChain(EthereumChain newChain) {
    _chain = newChain;
  }

  /// The reactive web3 client for blockchain calls.
  final ValueStream<Web3Client> _reactiveWeb3Client;

  /// Wallet repository for signing transactions and reading chain/account.
  final WalletRepository _walletRepository;

  /// The user's wallet address (optional, for balance queries).
  final String? userAddress;

  /// The Synthetix V3 account id used for delegate/undelegate. Default: 1.
  final BigInt accountId;

  Web3Client get _web3Client => _reactiveWeb3Client.value;

  // Synthetix V3 CoreProxy addresses per chain
  static const String _coreProxyAddressPolygon = SynthetixConfig.coreProxy;
  static const String _coreProxyAddressSepolia = SynthetixConfig.sepoliaCoreProxy;

  // Pool IDs for Spartan Council Pool (commonly used for testing)
  static final BigInt _spartanPoolId = BigInt.from(1);

  // Default leverage (1x) encoded with 18 decimals.
  static final BigInt _oneXLeverage = BigInt.from(10).pow(18);

  // Collateral addresses on Sepolia
  static const String _wbtcSepolia =
      '0x27c54ab10d69c852821e6ff64292867c0e9c387c';

  String get _coreProxyAddress {
    return _chain == EthereumChain.polygonMainnet
        ? _coreProxyAddressPolygon
        : _coreProxyAddressSepolia;
  }

  /// Fetch all available vaults for the current chain.
  ///
  /// Pass [overrideAccountId] to load the user's deposited balance for a
  /// specific Synthetix account (e.g. from AccountBloc.state.synthetixAccountId).
  /// When null (or zero), balances are returned as 0.0 gracefully.
  Future<List<VaultData>> fetchVaults({BigInt? overrideAccountId}) async {
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );

      if (_chain == EthereumChain.polygonMainnet) {
        return _fetchPolygonVaults(coreProxy, overrideAccountId: overrideAccountId);
      }
      return _fetchSepoliaVaults(coreProxy, overrideAccountId: overrideAccountId);
    } catch (e) {
      debugPrint('Error fetching vaults: $e');
      return _getFallbackVaults();
    }
  }

  /// Calculate total platform TVL across all vaults
  Future<double> getPlatformTVL() async {
    try {
      final vaults = await fetchVaults();
      return vaults.fold<double>(0, (sum, vault) => sum + vault.tvl);
    } catch (e) {
      debugPrint('Error calculating platform TVL: $e');
      return _chain == EthereumChain.polygonMainnet ? 1100000.0 : 4850000.0;
    }
  }

  /// Fetch vaults for Ethereum Sepolia
  Future<List<VaultData>> _fetchSepoliaVaults(
    SynthetixCoreProxy coreProxy, {
    BigInt? overrideAccountId,
  }) async {
    // AX, WBTC, and WETH addresses on Sepolia
    const axAddress = SynthetixConfig.axToken;
    const wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    // Fetch vault data for all collaterals
    final axVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'AX',
      collateralAddress: axAddress,
      poolId: _spartanPoolId,
      overrideAccountId: overrideAccountId,
    );

    final wbtcVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'WBTC',
      collateralAddress: wbtcAddress,
      poolId: _spartanPoolId,
      overrideAccountId: overrideAccountId,
    );

    final wethVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'WETH',
      collateralAddress: wethAddress,
      poolId: _spartanPoolId,
      overrideAccountId: overrideAccountId,
    );

    return [axVault, wbtcVault, wethVault];
  }

  /// Fetch vaults for Polygon Mainnet — only AX collateral is active.
  Future<List<VaultData>> _fetchPolygonVaults(
    SynthetixCoreProxy coreProxy, {
    BigInt? overrideAccountId,
  }) async {
    const axAddress = SynthetixConfig.axToken;
    final axVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'AX',
      collateralAddress: axAddress,
      poolId: _spartanPoolId,
      overrideAccountId: overrideAccountId,
    );
    return [axVault];
  }

  /// Fetch data for a specific vault
  Future<VaultData> _fetchVaultData({
    required SynthetixCoreProxy coreProxy,
    required String symbol,
    required String collateralAddress,
    required BigInt poolId,
    BigInt? overrideAccountId,
  }) async {
    try {
      final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);

      // Get vault collateral (TVL)
      final vaultCollateral = await coreProxy.getVaultCollateral(
        poolId,
        collateralEthAddress,
      );

      // Get user's deposited balance (on-chain via getAccountCollateral)
      var userBalance = 0.0;
      final resolvedAccountId = overrideAccountId ?? accountId;
      if (resolvedAccountId != BigInt.zero) {
        userBalance = await getUserBalance(
          collateralAddress: collateralAddress,
          poolId: poolId,
          overrideAccountId: resolvedAccountId,
        );
      }

      // Get collateral token decimals for conversion
      final token = erc20_api.ERC20(
        address: collateralEthAddress,
        client: _web3Client,
      );
      final decimals = await token.decimals();

      // Convert BigInt to double (accounting for decimals)
      final tvlRaw = vaultCollateral.amount;
      final tvl = _bigIntToDouble(tvlRaw, decimals.toInt());

      // Calculate APY from RewardDistributor contract
      final apy = await _calculateAPY(symbol: symbol, tvl: tvl);

      return VaultData(
        symbol: symbol,
        balance: userBalance,
        tvl: tvl,
        apy: apy,
        vaultAddress: _coreProxyAddress,
        collateralAddress: collateralAddress,
        poolId: poolId,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error fetching vault data for $symbol: $e');
      // Return fallback data for this vault
      return VaultData(
        symbol: symbol,
        balance: 0,
        tvl: _fallbackTvlForSymbol(symbol),
        apy: _getFallbackAPY(symbol),
        vaultAddress: _coreProxyAddress,
        collateralAddress: collateralAddress,
        poolId: poolId,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Fetch a specific vault by symbol.
  Future<VaultData?> fetchVault(String symbol) async {
    final vaults = await fetchVaults();
    try {
      return vaults.firstWhere((v) => v.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  /// Get user's deposited balance in a vault via Synthetix getAccountCollateral.
  ///
  /// Returns [totalAssigned] — the amount actively delegated to pools.
  /// Returns 0.0 gracefully when [overrideAccountId] is zero (no account yet).
  Future<double> getUserBalance({
    required String collateralAddress,
    required BigInt poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;

    // No Synthetix account yet — return 0 gracefully
    if (resolvedAccountId == BigInt.zero) {
      return 0.0;
    }

    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final result = await coreProxy.getAccountCollateral(
        resolvedAccountId,
        EthereumAddress.fromHex(collateralAddress),
      );

      // Fetch token decimals for proper conversion
      final token = erc20_api.ERC20(
        address: EthereumAddress.fromHex(collateralAddress),
        client: _web3Client,
      );
      final decimals = await token.decimals();

      // totalAssigned = collateral currently delegated to pools
      return _bigIntToDouble(result.totalAssigned, decimals.toInt());
    } catch (e) {
      debugPrint('Error getting account collateral balance: $e');
      return 0.0;
    }
  }

  /// Get collateral token decimals for a given collateral address.
  Future<int> getCollateralDecimals(String collateralAddress) async {
    final token = erc20_api.ERC20(
      address: EthereumAddress.fromHex(collateralAddress),
      client: _web3Client,
    );
    final decimals = await token.decimals();
    return decimals.toInt();
  }

  /// Deposit into a vault.
  Future<String> deposit({
    required VaultData vault,
    required double amount,
  }) async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final collateralAddress = EthereumAddress.fromHex(vault.collateralAddress);
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final userEthAddress = EthereumAddress.fromHex(userAddress!);

    // 1) Approve CoreProxy to spend the collateral
    final token =
        erc20_api.ERC20(address: collateralAddress, client: _web3Client);
    final decimals = await token.decimals();
    final amountWei = _doubleToBigInt(amount, decimals.toInt());

    final currentAllowance =
        await token.allowance(userEthAddress, coreProxyAddress);
    if (currentAllowance < amountWei) {
      await token.approve(coreProxyAddress, amountWei,
          credentials: credentials,);
    }

    // 2) Delegate collateral to the Spartan Council pool
    final coreProxy =
        SynthetixCoreProxy(address: coreProxyAddress, client: _web3Client);
    final txHash = await coreProxy.delegateCollateral(
      accountId,
      vault.poolId,
      collateralAddress,
      amountWei,
      _oneXLeverage,
      credentials: credentials,
    );

    return txHash;
  }

  /// Withdraw from a vault.
  Future<String> withdraw({
    required VaultData vault,
    required double amount,
  }) async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final collateralAddress = EthereumAddress.fromHex(vault.collateralAddress);
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);

    final token =
        erc20_api.ERC20(address: collateralAddress, client: _web3Client);
    final decimals = await token.decimals();
    final amountWei = _doubleToBigInt(amount, decimals.toInt());

    final coreProxy =
        SynthetixCoreProxy(address: coreProxyAddress, client: _web3Client);
    final txHash = await coreProxy.undelegateCollateral(
      accountId,
      vault.poolId,
      collateralAddress,
      amountWei,
      credentials: credentials,
    );

    return txHash;
  }

  /// Mint (borrow) synthetic USD against delegated collateral.
  /// Requires collateral to be delegated first via deposit().
  Future<String> mintStablecoins({
    required double amount,
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
    final pool = poolId ?? _spartanPoolId;

    // sUSD decimals (typically 18)
    const susdDecimals = 18;
    final amountWei = _doubleToBigInt(amount, susdDecimals);

    // Use delegateCollateral pattern but call mintUsd
    final coreProxy = SynthetixCoreProxy(
      address: coreProxyAddress,
      client: _web3Client,
    );

    final function = coreProxy.self.function('mintUsd');
    final transaction = Transaction.callContract(
      contract: coreProxy.self,
      function: function,
      parameters: [accountId, pool, collateralEthAddress, amountWei],
    );

    return _web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  /// Burn (repay) synthetic USD debt.
  Future<String> burnStablecoins({
    required double amount,
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
    final pool = poolId ?? _spartanPoolId;

    const susdDecimals = 18;
    final amountWei = _doubleToBigInt(amount, susdDecimals);

    final coreProxy = SynthetixCoreProxy(
      address: coreProxyAddress,
      client: _web3Client,
    );

    final function = coreProxy.self.function('burnUsd');
    final transaction = Transaction.callContract(
      contract: coreProxy.self,
      function: function,
      parameters: [accountId, pool, collateralEthAddress, amountWei],
    );

    return _web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  /// Get per-position debt for the account via CoreProxy.getPositionDebt.
  ///
  /// Returns the signed int256 debt cast to BigInt (positive = owes sUSD).
  /// Returns zero gracefully when accountId is unset.
  Future<BigInt> getPositionDebt({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return BigInt.zero;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      return await coreProxy.getPositionDebt(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
    } catch (e) {
      debugPrint('Error getting position debt: $e');
      return BigInt.zero;
    }
  }

  /// Get max sUSD borrow amount for the account.
  ///
  /// Derived from the position's assigned collateral and a minimum safe
  /// c-ratio of 200% (2×). Formula:
  ///   maxBorrow = getPositionCollateral.amount / 2  (in collateral tokens)
  /// Returns zero gracefully when accountId is unset or position empty.
  Future<BigInt> getMaxBorrowAmount({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return BigInt.zero;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final positionAmount = await coreProxy.getPositionCollateral(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
      // At 200% min c-ratio, max borrowable = 50% of collateral value
      return positionAmount ~/ BigInt.two;
    } catch (e) {
      debugPrint('Error getting max borrow amount: $e');
      return BigInt.zero;
    }
  }

  /// Get live collateralization ratio for the account position.
  ///
  /// Calls CoreProxy.getPositionCollateralRatio which returns a uint256 in
  /// 18-decimal precision (e.g. 2e18 = 200%). Converts to a plain percentage.
  /// Returns 0.0 gracefully when accountId is unset or no position exists.
  Future<double> getCollateralRatio({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return 0.0;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final ratioRaw = await coreProxy.getPositionCollateralRatio(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
      // ratioRaw is in 18 decimals: 1e18 = 100%
      // Divide by 1e16 to convert to percentage (e.g. 2e18 / 1e16 = 200.0)
      return ratioRaw == BigInt.zero
          ? 0.0
          : ratioRaw.toDouble() / 1e16;
    } catch (e) {
      debugPrint('Error getting collateral ratio: $e');
      return 0.0;
    }
  }

  /// Get transaction receipt to verify transaction confirmation
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    try {
      return await _web3Client.getTransactionReceipt(txHash);
    } catch (e) {
      debugPrint('Error getting transaction receipt: $e');
      return null;
    }
  }

  BigInt _doubleToBigInt(double amount, int decimals) {
    final factor = math.pow(10, decimals);
    return BigInt.from((amount * factor).round());
  }

  /// Convert BigInt to double accounting for token decimals
  double _bigIntToDouble(BigInt value, int decimals) {
    if (decimals == 0) return value.toDouble();
    final divisor = BigInt.from(10).pow(decimals);
    return value / divisor;
  }

  /// Calculate APY for the given collateral symbol.
  ///
  /// On Polygon: reads the live reward rate from CoreProxy.getRewardRate() and
  /// annualises it against the vault TVL. Returns 0.0 when the RewardsDistributor
  /// has not yet been deployed or funded.
  ///
  /// On Sepolia: always returns 0.0 until a distributor is deployed there.
  Future<double> _calculateAPY({
    required String symbol,
    required double tvl,
  }) async {
    if (_chain != EthereumChain.polygonMainnet) return 0.0;
    const distributorAddress = SynthetixConfig.rewardsDistributor;
    if (distributorAddress.isEmpty || tvl <= 0) return 0.0;

    try {
      // getRewardRate(poolId, collateralType, distributor) → tokens/second in 18-dec precision
      const getRewardRateAbi =
          '[{"inputs":[{"name":"poolId","type":"uint128"},{"name":"collateralType","type":"address"},{"name":"distributor","type":"address"}],"name":"getRewardRate","outputs":[{"name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]';
      final abi = web3.ContractAbi.fromJson(getRewardRateAbi, 'CoreProxy');
      final contract = web3.DeployedContract(
        abi,
        EthereumAddress.fromHex(_coreProxyAddress),
      );
      final fn = contract.function('getRewardRate');
      final result = await _web3Client.call(
        contract: contract,
        function: fn,
        params: [
          _spartanPoolId,
          EthereumAddress.fromHex(SynthetixConfig.axToken),
          EthereumAddress.fromHex(distributorAddress),
        ],
      );
      final rateRaw = result[0] as BigInt;
      if (rateRaw == BigInt.zero) return 0.0;
      // rateRaw is in 18-decimal axUSD per second; TVL is in AX tokens (oracle $1 each)
      final ratePerSecond = rateRaw.toDouble() / 1e18;
      final annualRewards = ratePerSecond * 365 * 24 * 3600;
      return (annualRewards / tvl) * 100;
    } catch (e) {
      debugPrint('APY calculation error: $e');
      return 0.0;
    }
  }

  /// Fallback APY when _calculateAPY throws.
  double _getFallbackAPY(String symbol) => 0.0;

  /// Fallback TVL for a single vault when the on-chain call fails.
  double _fallbackTvlForSymbol(String symbol) {
    if (_chain == EthereumChain.polygonMainnet) return 1100000.0;
    switch (symbol) {
      case 'WBTC': return 1250000.0;
      case 'WETH': return 2850000.0;
      default:     return 750000.0; // AX on Sepolia
    }
  }

  /// Get fallback vault data when blockchain calls fail.
  List<VaultData> _getFallbackVaults() {
    if (_chain == EthereumChain.polygonMainnet) return _getPolygonFallbackVaults();
    return _getSepoliaFallbackVaults();
  }

  List<VaultData> _getPolygonFallbackVaults() {
    return [
      VaultData(
        symbol: 'AX',
        balance: 0,
        tvl: 1100000,
        apy: 0,
        vaultAddress: _coreProxyAddressPolygon,
        collateralAddress: SynthetixConfig.axToken,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }

  List<VaultData> _getSepoliaFallbackVaults() {
    const axAddress = SynthetixConfig.axToken;
    const wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    return [
      VaultData(
        symbol: 'AX',
        balance: 0,
        tvl: 750000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: axAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WBTC',
        balance: 0,
        tvl: 1250000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wbtcAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WETH',
        balance: 0,
        tvl: 2850000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wethAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }

}
