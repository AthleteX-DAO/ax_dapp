/// Enhanced Synthetix configuration for AthleteX protocol operations
/// Extends SynthetixConfig with collateral, pool, and strategy settings
class AthleteXSynthetixConfig {
  /// Primary collateral token address (USDC on Base/Sepolia)
  static const String primaryCollateralAddress =
      '0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913'; // USDC on Base
  
  /// Primary collateral token decimals
  static const int primaryCollateralDecimals = 6;
  
  /// Primary collateral symbol
  static const String primaryCollateralSymbol = 'USDC';

  /// Default pool ID for AthleteX operations (main liquidity pool)
  static const int defaultPoolId = 1;

  /// Pool name for display
  static const String defaultPoolName = 'Spartan Council Pool';

  /// Minimum collateral ratio before liquidation risk
  /// C-ratio = collateral_value / debt_value
  /// At 1.5, position can be liquidated
  static const double minSafeCollateralizationRatio = 1.5;

  /// Target collateral ratio for new deposits
  /// Recommended safe target
  static const double targetCollateralizationRatio = 2.5;

  /// Maximum collateral ratio (diminishing returns)
  static const double maxOptimalCollateralizationRatio = 5.0;

  /// Multicall3 address (same on most EVM chains)
  static const String multicall3Address =
      '0xcA11bde05977b3631167028862bE2a173976CA11';

  /// Poll interval for monitoring Synthetix account state (milliseconds)
  static const Duration accountPollingInterval = Duration(seconds: 10);

  /// Cache TTL for Synthetix data (milliseconds)
  static const Duration cacheTTL = Duration(seconds: 10);

  /// Maximum number of retries for RPC calls
  static const int maxRetries = 3;

  /// Initial backoff duration for retries (exponential)
  static const Duration initialBackoff = Duration(milliseconds: 500);

  /// Per-operation timeouts
  static const Duration rpcTimeout = Duration(seconds: 10);
  static const Duration transactionTimeout = Duration(minutes: 2);

  /// Map of supported collateral types (address => symbol)
  static Map<String, String> get supportedCollaterals => {
    primaryCollateralAddress: primaryCollateralSymbol,
    // Future: add more collateral types here
    // '0xOther': 'OTHER_SYMBOL',
  };

  /// Get collateral info by address
  static CollateralInfo? getCollateralInfo(String address) {
    if (address.toLowerCase() == primaryCollateralAddress.toLowerCase()) {
      return CollateralInfo(
        address: primaryCollateralAddress,
        symbol: primaryCollateralSymbol,
        decimals: primaryCollateralDecimals,
        isDefault: true,
      );
    }
    return null;
  }

  /// Returns true if address is a supported collateral
  static bool isSupportedCollateral(String address) {
    return supportedCollaterals.keys
        .any((addr) => addr.toLowerCase() == address.toLowerCase());
  }
}

/// Information about a supported collateral token
class CollateralInfo {
  const CollateralInfo({
    required this.address,
    required this.symbol,
    required this.decimals,
    required this.isDefault,
  });

  final String address;
  final String symbol;
  final int decimals;
  final bool isDefault;

  /// Converts amount from decimal to raw (wei)
  BigInt toRaw(double amount) {
    final divisor = BigInt.from(10).pow(decimals);
    return BigInt.from((amount * (divisor).toDouble()).toInt());
  }

  /// Converts amount from raw (wei) to decimal
  double toDecimal(BigInt amount) {
    final divisor = BigInt.from(10).pow(decimals);
    return amount.toDouble() / divisor.toDouble();
  }
}
