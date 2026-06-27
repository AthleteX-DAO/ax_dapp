/// Enhanced Synthetix configuration for AthleteX protocol operations
/// Extends SynthetixConfig with collateral, pool, and strategy settings
class AthleteXSynthetixConfig {
  /// Returns the default collateral address for [chainId].
  static String defaultCollateralAddress(int chainId) =>
      collateralsForChain(chainId).firstWhere((c) => c.isDefault).address;

  /// Primary collateral token decimals
  static const int primaryCollateralDecimals = 18;

  /// Primary collateral symbol
  static const String primaryCollateralSymbol = 'AX';

  /// Default pool ID for AthleteX operations (main liquidity pool)
  static const int defaultPoolId = 1;

  /// Pool name for display
  static const String defaultPoolName = 'AthleteX Main Pool';

  /// Minimum collateral ratio before liquidation risk
  static const double minSafeCollateralizationRatio = 1.5;

  /// Target collateral ratio for new deposits
  static const double targetCollateralizationRatio = 2.5;

  /// Maximum collateral ratio (diminishing returns)
  static const double maxOptimalCollateralizationRatio = 5;

  /// Multicall3 address (same on most EVM chains)
  static const String multicall3Address =
      '0xcA11bde05977b3631167028862bE2a173976CA11';

  /// Poll interval for monitoring Synthetix account state
  static const Duration accountPollingInterval = Duration(seconds: 10);

  /// Cache TTL for Synthetix data
  static const Duration cacheTTL = Duration(seconds: 10);

  /// Maximum number of retries for RPC calls
  static const int maxRetries = 3;

  /// Initial backoff duration for retries (exponential)
  static const Duration initialBackoff = Duration(milliseconds: 500);

  /// Per-operation timeouts
  static const Duration rpcTimeout = Duration(seconds: 10);
  static const Duration transactionTimeout = Duration(minutes: 2);

  // ======== Chain IDs ========
  static const int sepoliaChainId = 11155111;
  static const int polygonChainId = 137;

  // ======== Collateral registries per chain ========

  /// All supported collaterals keyed by chain ID then lower-cased address.
  static const Map<int, List<CollateralInfo>> _collateralsByChain = {
    sepoliaChainId: _sepoliaCollaterals,
    polygonChainId: _polygonCollaterals,
  };

  static const List<CollateralInfo> _sepoliaCollaterals = [
    CollateralInfo(
      address: '0xDc5Aa90C7ce823cFBc62aBC3c035c609a97a0A3C',
      symbol: 'AX',
      decimals: 18,
      isDefault: true,
      isWrappable: false,
      minDelegation: 100.0,
    ),
    CollateralInfo(
      address: '0xC2567853F68299DeaFcB5B5c3b00a5a6bCA88f42',
      symbol: 'USDC',
      decimals: 6,
      isDefault: false,
      isWrappable: true,
    ),
    CollateralInfo(
      address: '0x4E7374B31Aa01BdFd8A7d4cf929c02Ba4a2B70Be',
      symbol: 'USDT',
      decimals: 6,
      isDefault: false,
      isWrappable: true,
    ),
    CollateralInfo(
      address: '0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14',
      symbol: 'WETH',
      decimals: 18,
      isDefault: false,
      isWrappable: true,
    ),
  ];

  /// AX token on Polygon mainnet.
  /// Contract: https://polygonscan.com/token/0x5617604BA0a30E0ff1d2163aB94E50d8b6D0B0Df

  static const List<CollateralInfo> _polygonCollaterals = [
    CollateralInfo(
      address: '0x5617604BA0a30E0ff1d2163aB94E50d8b6D0B0Df',
      symbol: 'AX',
      decimals: 18,
      isDefault: true,
      isWrappable: false,
      minDelegation: 100.0,
    ),
    CollateralInfo(
      address: '0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359',
      symbol: 'USDC',
      decimals: 6,
      isDefault: false,
      isWrappable: true,
    ),
    CollateralInfo(
      address: '0xc2132D05D31c914a87C6611C10748AEb04B58e8F',
      symbol: 'USDT',
      decimals: 6,
      isDefault: false,
      isWrappable: true,
    ),
    CollateralInfo(
      address: '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619',
      symbol: 'WETH',
      decimals: 18,
      isDefault: false,
      isWrappable: true,
    ),
    CollateralInfo(
      address: '0x1BFD67037B42Cf73acF2047067bd4F2C47D9BfD6',
      symbol: 'WBTC',
      decimals: 8,
      isDefault: false,
      isWrappable: true,
    ),
  ];

  /// Returns all supported collaterals for [chainId].
  /// Falls back to Sepolia list when chain is unknown.
  static List<CollateralInfo> collateralsForChain(int chainId) =>
      _collateralsByChain[chainId] ?? _polygonCollaterals;

  /// Returns all wrappable collaterals for [chainId].
  static List<CollateralInfo> wrappableCollateralsForChain(int chainId) =>
      collateralsForChain(chainId)
          .where((c) => c.isWrappable)
          .toList(growable: false);

  /// Get collateral info by address (case-insensitive) for [chainId].
  static CollateralInfo? getCollateralInfo(
    String address, {
    required int chainId,
  }) {
    final lower = address.toLowerCase();
    try {
      return collateralsForChain(chainId)
          .firstWhere((c) => c.address.toLowerCase() == lower);
    } catch (_) {
      return null;
    }
  }

  /// Returns true if address is a supported collateral on [chainId].
  static bool isSupportedCollateral(
    String address, {
    required int chainId,
  }) =>
      getCollateralInfo(address, chainId: chainId) != null;
}

/// Information about a supported collateral token.
///
/// [isWrappable] means the token can be deposited via SpotMarket `wrap()`
/// to mint a synthetic equivalent (e.g. USDC → axUSDC) without going
/// through the LP deposit→delegate→mint path.
class CollateralInfo {
  const CollateralInfo({
    required this.address,
    required this.symbol,
    required this.decimals,
    required this.isDefault,
    required this.isWrappable,
    this.minDelegation = 0.0,
  });

  final String address;
  final String symbol;
  final int decimals;

  /// True if this is the default collateral shown on first launch.
  final bool isDefault;

  /// True if this token can be wrapped via SpotMarket (Trader path).
  /// False = LP path only (deposit → delegate → mint → trade).
  final bool isWrappable;

  /// Minimum delegation amount required by the Synthetix core system.
  final double minDelegation;

  /// Converts a decimal [amount] to raw wei representation.
  BigInt toRaw(double amount) {
    final divisor = BigInt.from(10).pow(decimals);
    return BigInt.from((amount * divisor.toDouble()).truncate());
  }

  /// Converts a raw [amount] (wei) to a human-readable decimal.
  double toDecimal(BigInt amount) {
    final divisor = BigInt.from(10).pow(decimals);
    return amount.toDouble() / divisor.toDouble();
  }

  @override
  bool operator ==(Object other) =>
      other is CollateralInfo &&
      other.address.toLowerCase() == address.toLowerCase();

  @override
  int get hashCode => address.toLowerCase().hashCode;
}
