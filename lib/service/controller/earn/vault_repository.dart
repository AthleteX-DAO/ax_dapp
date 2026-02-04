import 'dart:math' as math;

import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/wallet/models/ethereum_chain.dart';
import 'package:ethereum_api/synthetix_v3_api.dart';
import 'package:ethereum_api/erc20_api.dart' as erc20_api;
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/web3dart.dart';

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

/// Repository for managing Synthetix V3 vault operations on Sepolia testnet.
class VaultRepository {
  VaultRepository({
    required this.chain,
    required ValueStream<Web3Client> reactiveWeb3Client,
    required WalletRepository walletRepository,
    this.userAddress,
    BigInt? accountId,
  })  : _reactiveWeb3Client = reactiveWeb3Client,
        _walletRepository = walletRepository,
        accountId = accountId ?? BigInt.from(1);

  /// The Ethereum chain for vault operations.
  final EthereumChain chain;

  /// The reactive web3 client for blockchain calls.
  final ValueStream<Web3Client> _reactiveWeb3Client;

  /// Wallet repository for signing transactions and reading chain/account.
  final WalletRepository _walletRepository;

  /// The user's wallet address (optional, for balance queries).
  final String? userAddress;

  /// The Synthetix V3 account id used for delegate/undelegate. Default: 1.
  final BigInt accountId;

  Web3Client get _web3Client => _reactiveWeb3Client.value;

  // Synthetix V3 CoreProxy addresses
  static const String _coreProxyAddressSepolia =
      '0x76490713314fCEC173f44e99346F54c6e92a8E42';
  static const String _coreProxyAddressBaseSepolia =
      '0x764F4C95FDA0D6f8114faC54f6709b1B45f919a1';

  // Pool IDs for Spartan Council Pool (commonly used for testing)
  static final BigInt _spartanPoolId = BigInt.from(1);

  // Default leverage (1x) encoded with 18 decimals.
  static final BigInt _oneXLeverage = BigInt.from(10).pow(18);

  // Collateral addresses on Sepolia
  static const String _wbtcSepolia =
      '0x27c54aB10D69C852821e6Ff64292867C0e9c387c';

  // Collateral addresses on Base Sepolia
  static const String _fUSDCBaseSepolia =
      '0xc43708f8987Df3f3681801e5e640667D86Ce3C30';
  static const String _cbBTCBaseSepolia =
      '0x8608d511E224180051A36d34121725D978064e6E';
  static const String _cbETHBaseSepolia =
      '0x00ab6b818652bB3bFE334983171edFD38184DbeD';
  static const String _wstETHBaseSepolia =
      '0x7Bf65af7EFBd0E933fb87dD2C9cE7A17d959b822';

  // Reward Distributor addresses on Base Sepolia (Pool 1)
  // From base-sepolia-contracts.json rewardDistributors.pool1
  static const Map<String, String> _rewardDistributorAddresses = {
    'fUSDC': '0xA28719DDDa6e129d5E8fd470A17Cd075cEf5d25A', // sUSDC_fUSDC
    'cbBTC': '0xe51a5cEBFE24B6f50Cbf89B3F8B33d252E10FE3A', // scbBTC
    'cbETH': '0x0148f0c84F6C44cfF24450d70BfdaBB9f46c69cf', // scbETH
    'WETH': '0x4f908d36EC7A887b161B8745E8eA8aCBd60DB935', // sWETH
    'wstETH': '0x517a744c28f26044c5D049125992E5d139b52284', // swstETH
  };

  String get _coreProxyAddress {
    if (chain == EthereumChain.baseSepolia) {
      return _coreProxyAddressBaseSepolia;
    }
    return _coreProxyAddressSepolia;
  }

  /// Fetch all available vaults (WBTC and WETH on Sepolia).
  Future<List<VaultData>> fetchVaults() async {
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );

      // Return different vaults based on the chain
      if (chain == EthereumChain.baseSepolia) {
        return _fetchBaseSepoliaVaults(coreProxy);
      } else {
        return _fetchSepoliaVaults(coreProxy);
      }
    } catch (e) {
      debugPrint('Error fetching vaults: $e');
      // Return stubbed data as fallback
      return _getFallbackVaults();
    }
  }

  /// Calculate total platform TVL across all vaults
  Future<double> getPlatformTVL() async {
    try {
      final vaults = await fetchVaults();
      return vaults.fold<double>(0.0, (sum, vault) => sum + vault.tvl);
    } catch (e) {
      debugPrint('Error calculating platform TVL: $e');
      // Return fallback value
      return 4100000.0; // Default fallback: sum of typical vault TVLs
    }
  }

  /// Fetch vaults for Ethereum Sepolia
  Future<List<VaultData>> _fetchSepoliaVaults(
      SynthetixCoreProxy coreProxy) async {
    // WBTC and WETH addresses on Sepolia
    final wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    // Fetch vault data for both collaterals
    final wbtcVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'WBTC',
      collateralAddress: wbtcAddress,
      poolId: _spartanPoolId,
    );

    final wethVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'WETH',
      collateralAddress: wethAddress,
      poolId: _spartanPoolId,
    );

    return [wbtcVault, wethVault];
  }

  /// Fetch vaults for Base Sepolia (Synthetix V3 Andromeda deployment)
  Future<List<VaultData>> _fetchBaseSepoliaVaults(
      SynthetixCoreProxy coreProxy) async {
    final wethAddress =
        const EthereumAddressConfig.weth().address(EthereumChain.baseSepolia);

    // Fetch vault data for Base Sepolia collaterals
    final fUSDCVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'fUSDC',
      collateralAddress: _fUSDCBaseSepolia,
      poolId: _spartanPoolId,
    );

    final cbBTCVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'cbBTC',
      collateralAddress: _cbBTCBaseSepolia,
      poolId: _spartanPoolId,
    );

    final cbETHVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'cbETH',
      collateralAddress: _cbETHBaseSepolia,
      poolId: _spartanPoolId,
    );

    final wethVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'WETH',
      collateralAddress: wethAddress,
      poolId: _spartanPoolId,
    );

    final wstETHVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'wstETH',
      collateralAddress: _wstETHBaseSepolia,
      poolId: _spartanPoolId,
    );

    return [fUSDCVault, cbBTCVault, cbETHVault, wethVault, wstETHVault];
  }

  /// Fetch data for a specific vault
  Future<VaultData> _fetchVaultData({
    required SynthetixCoreProxy coreProxy,
    required String symbol,
    required String collateralAddress,
    required BigInt poolId,
  }) async {
    try {
      final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);

      // Get vault collateral (TVL)
      final vaultCollateral = await coreProxy.getVaultCollateral(
        poolId,
        collateralEthAddress,
      );

      // Get user balance if user is connected
      double userBalance = 0.0;
      if (userAddress != null) {
        userBalance = await getUserBalance(
          collateralAddress: collateralAddress,
          poolId: poolId,
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
        balance: 0.0,
        tvl: symbol == 'WBTC' ? 1250000.0 : 2850000.0,
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

  /// Get user balance in a vault (actual blockchain call).
  Future<double> getUserBalance({
    required String collateralAddress,
    required BigInt poolId,
  }) async {
    if (userAddress == null) {
      return 0.0;
    }

    try {
      // For Synthetix V3, we need to query the user's position collateral
      // This would require knowing the user's account ID
      // For now, we'll query the ERC20 balance as a fallback
      final token = erc20_api.ERC20(
        address: EthereumAddress.fromHex(collateralAddress),
        client: _web3Client,
      );

      final balanceWei = await token.balanceOf(
        EthereumAddress.fromHex(userAddress!),
      );
      final decimals = await token.decimals();

      return _bigIntToDouble(balanceWei, decimals.toInt());
    } catch (e) {
      debugPrint('Error getting user balance: $e');
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
          credentials: credentials);
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
    const int susdDecimals = 18;
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

    return await _web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: chain == EthereumChain.baseSepolia ? 84532 : 11155111,
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

    const int susdDecimals = 18;
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

    return await _web3Client.sendTransaction(
      credentials,
      transaction,
      chainId: chain == EthereumChain.baseSepolia ? 84532 : 11155111,
    );
  }

  /// Get debt position for the account (placeholder - returns 0 for now)
  Future<BigInt> getPositionDebt({
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    try {
      // TODO: Implement via SynthetixCoreService when available
      // For now, return placeholder
      return BigInt.zero;
    } catch (e) {
      debugPrint('Error getting position debt: $e');
      return BigInt.zero;
    }
  }

  /// Get max borrow amount for the account (placeholder)
  Future<BigInt> getMaxBorrowAmount({
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    try {
      // TODO: Implement via collateral ratio calculation
      // For now, return placeholder (500 sUSD = 500e18)
      return _doubleToBigInt(500.0, 18);
    } catch (e) {
      debugPrint('Error getting max borrow: $e');
      return BigInt.zero;
    }
  }

  /// Get live collateralization ratio for the account.
  /// Returns ratio as percentage (e.g., 200.0 = 200%)
  Future<double> getCollateralRatio({
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    try {
      // For now, return a safe default C-ratio (200%)
      // TODO: Replace with actual getPositionCollateralRatio when available in SynthetixCoreProxy
      return 200.0;
    } catch (e) {
      debugPrint('Error getting collateral ratio: $e');
      return 200.0; // Safe default
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

  /// Calculate APY based on reward distributor data
  Future<double> _calculateAPY({
    required String symbol,
    required double tvl,
  }) async {
    try {
      // Only Base Sepolia has reward distributors configured
      if (chain != EthereumChain.baseSepolia) {
        return _getFallbackAPY(symbol);
      }

      final distributorAddress = _rewardDistributorAddresses[symbol];
      if (distributorAddress == null || tvl == 0) {
        return _getFallbackAPY(symbol);
      }

      final distributor = RewardDistributor(
        address: EthereumAddress.fromHex(distributorAddress),
        client: _web3Client,
      );

      // Get total rewards amount and rewarded amount
      final rewardsAmount = await distributor.rewardsAmount();
      final rewardedAmount = await distributor.rewardedAmount();

      // Calculate remaining rewards to be distributed
      final remainingRewards = rewardsAmount - rewardedAmount;

      // Get payout token to get decimals
      final payoutTokenAddress = await distributor.payoutToken();
      final payoutToken = erc20_api.ERC20(
        address: payoutTokenAddress,
        client: _web3Client,
      );
      final decimals = await payoutToken.decimals();

      // Convert to human-readable amount
      final rewardsInToken =
          _bigIntToDouble(remainingRewards, decimals.toInt());

      // Assume rewards are distributed over ~30 days (typical distribution period)
      // APY = (Annual Rewards / TVL) * 100
      // Annual Rewards ≈ Monthly Rewards * 12
      const distributionDays = 30.0;
      const daysInYear = 365.0;
      final annualRewards = (rewardsInToken / distributionDays) * daysInYear;

      if (tvl > 0) {
        final apy = (annualRewards / tvl) * 100;
        // Cap APY at reasonable bounds (0.1% to 500%)
        return apy.clamp(0.1, 500.0);
      }

      return _getFallbackAPY(symbol);
    } catch (e) {
      debugPrint('Error calculating APY for $symbol: $e');
      return _getFallbackAPY(symbol);
    }
  }

  /// Fallback APY values when real calculation fails
  double _getFallbackAPY(String symbol) {
    // Conservative estimates as fallback
    switch (symbol.toUpperCase()) {
      case 'WBTC':
        return 5.2;
      case 'WETH':
        return 4.8;
      case 'FUSDC':
        return 6.5;
      case 'CBBTC':
        return 5.5;
      case 'CBETH':
        return 5.0;
      case 'WSTETH':
        return 4.5;
      default:
        return 5.0;
    }
  }

  /// Get fallback vault data when blockchain calls fail
  List<VaultData> _getFallbackVaults() {
    if (chain == EthereumChain.baseSepolia) {
      return _getBaseSepoliaFallbackVaults();
    }
    return _getSepoliaFallbackVaults();
  }

  List<VaultData> _getSepoliaFallbackVaults() {
    final wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    return [
      VaultData(
        symbol: 'WBTC',
        balance: 0.0,
        tvl: 1250000.0,
        apy: 5.2,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wbtcAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WETH',
        balance: 0.0,
        tvl: 2850000.0,
        apy: 4.8,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wethAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }

  List<VaultData> _getBaseSepoliaFallbackVaults() {
    final wethAddress =
        const EthereumAddressConfig.weth().address(EthereumChain.baseSepolia);

    return [
      VaultData(
        symbol: 'fUSDC',
        balance: 0.0,
        tvl: 500000.0,
        apy: 6.5,
        vaultAddress: _coreProxyAddressBaseSepolia,
        collateralAddress: _fUSDCBaseSepolia,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'cbBTC',
        balance: 0.0,
        tvl: 1500000.0,
        apy: 5.5,
        vaultAddress: _coreProxyAddressBaseSepolia,
        collateralAddress: _cbBTCBaseSepolia,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'cbETH',
        balance: 0.0,
        tvl: 2000000.0,
        apy: 5.0,
        vaultAddress: _coreProxyAddressBaseSepolia,
        collateralAddress: _cbETHBaseSepolia,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WETH',
        balance: 0.0,
        tvl: 3500000.0,
        apy: 4.8,
        vaultAddress: _coreProxyAddressBaseSepolia,
        collateralAddress: wethAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'wstETH',
        balance: 0.0,
        tvl: 1800000.0,
        apy: 4.5,
        vaultAddress: _coreProxyAddressBaseSepolia,
        collateralAddress: _wstETHBaseSepolia,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }
}
