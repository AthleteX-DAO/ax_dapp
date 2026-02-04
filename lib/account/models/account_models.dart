import 'package:equatable/equatable.dart';

/// Represents a token held in the user's wallet (not on the protocol)
class WalletAsset extends Equatable {
  const WalletAsset({
    required this.address,
    required this.symbol,
    required this.name,
    required this.decimals,
    required this.balance,
    required this.balanceInUsd,
  });

  /// Token contract address
  final String address;

  /// Token symbol (e.g., 'USDC', 'ETH')
  final String symbol;

  /// Token name (e.g., 'USD Coin')
  final String name;

  /// Token decimals (e.g., 18 for most ERC20s, 6 for USDC)
  final int decimals;

  /// Raw balance in smallest unit (wei for 18 decimals)
  final BigInt balance;

  /// USD value of balance
  final double balanceInUsd;

  /// Returns balance as human-readable decimal
  double get balanceDecimal {
    final divisor = BigInt.from(10).pow(decimals);
    return balance.toDouble() / divisor.toDouble();
  }

  WalletAsset copyWith({
    String? address,
    String? symbol,
    String? name,
    int? decimals,
    BigInt? balance,
    double? balanceInUsd,
  }) {
    return WalletAsset(
      address: address ?? this.address,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      decimals: decimals ?? this.decimals,
      balance: balance ?? this.balance,
      balanceInUsd: balanceInUsd ?? this.balanceInUsd,
    );
  }

  @override
  List<Object?> get props =>
      [address, symbol, name, decimals, balance, balanceInUsd];
}

/// Represents collateral deposited on the Synthetix protocol
class SynthetixCollateral extends Equatable {
  const SynthetixCollateral({
    required this.tokenAddress,
    required this.tokenSymbol,
    required this.tokenDecimals,
    required this.depositedAmount,
    required this.availableAmount,
    required this.lockedAmount,
    required this.depositedInUsd,
  });

  /// Collateral token contract address
  final String tokenAddress;

  /// Collateral token symbol (e.g., 'USDC')
  final String tokenSymbol;

  /// Collateral token decimals
  final int tokenDecimals;

  /// Total amount deposited as collateral
  final BigInt depositedAmount;

  /// Amount available to withdraw
  final BigInt availableAmount;

  /// Amount locked due to debt/positions
  final BigInt lockedAmount;

  /// USD value of deposited collateral
  final double depositedInUsd;

  /// Returns deposited amount as human-readable decimal
  double get depositedDecimal {
    final divisor = BigInt.from(10).pow(tokenDecimals);
    return depositedAmount.toDouble() / divisor.toDouble();
  }

  /// Returns available amount as human-readable decimal
  double get availableDecimal {
    final divisor = BigInt.from(10).pow(tokenDecimals);
    return availableAmount.toDouble() / divisor.toDouble();
  }

  /// Returns locked amount as human-readable decimal
  double get lockedDecimal {
    final divisor = BigInt.from(10).pow(tokenDecimals);
    return lockedAmount.toDouble() / divisor.toDouble();
  }

  /// Percentage of collateral that is locked
  double get lockPercentage =>
      depositedAmount == BigInt.zero
          ? 0
          : (lockedAmount.toDouble() / depositedAmount.toDouble()) * 100;

  SynthetixCollateral copyWith({
    String? tokenAddress,
    String? tokenSymbol,
    int? tokenDecimals,
    BigInt? depositedAmount,
    BigInt? availableAmount,
    BigInt? lockedAmount,
    double? depositedInUsd,
  }) {
    return SynthetixCollateral(
      tokenAddress: tokenAddress ?? this.tokenAddress,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenDecimals: tokenDecimals ?? this.tokenDecimals,
      depositedAmount: depositedAmount ?? this.depositedAmount,
      availableAmount: availableAmount ?? this.availableAmount,
      lockedAmount: lockedAmount ?? this.lockedAmount,
      depositedInUsd: depositedInUsd ?? this.depositedInUsd,
    );
  }

  @override
  List<Object?> get props => [
    tokenAddress,
    tokenSymbol,
    tokenDecimals,
    depositedAmount,
    availableAmount,
    lockedAmount,
    depositedInUsd,
  ];
}

/// Represents a position in a Synthetix pool (yield-earning position)
class ProtocolPosition extends Equatable {
  const ProtocolPosition({
    required this.poolId,
    required this.poolName,
    required this.collateralAddress,
    required this.debt,
    required this.debtInUsd,
    required this.collateralizationRatio,
    required this.isLiquidatable,
    required this.unrealizedPnl,
    required this.unrealizedPnlInUsd,
  });

  /// Synthetix pool ID
  final int poolId;

  /// Human-readable pool name
  final String poolName;

  /// Collateral token address for this position
  final String collateralAddress;

  /// Current debt owed (in smallest unit)
  final BigInt debt;

  /// USD value of debt
  final double debtInUsd;

  /// C-ratio: (deposited collateral) / (debt)
  /// Higher is safer, lower means more at risk of liquidation
  final double collateralizationRatio;

  /// Whether position can be liquidated
  final bool isLiquidatable;

  /// Unrealized profit/loss from position
  final BigInt unrealizedPnl;

  /// USD value of unrealized P&L
  final double unrealizedPnlInUsd;

  /// Safety level for liquidation (0-100)
  /// 100 = very safe, 0 = liquidation imminent
  double get liquidationSafetyPercentage {
    const minRatio = 1.5; // Minimum safe c-ratio
    if (collateralizationRatio <= minRatio) return 0;
    if (collateralizationRatio >= 3.0) return 100;
    // Linear interpolation between min and max safe ratios
    return ((collateralizationRatio - minRatio) / (3.0 - minRatio)) * 100;
  }

  ProtocolPosition copyWith({
    int? poolId,
    String? poolName,
    String? collateralAddress,
    BigInt? debt,
    double? debtInUsd,
    double? collateralizationRatio,
    bool? isLiquidatable,
    BigInt? unrealizedPnl,
    double? unrealizedPnlInUsd,
  }) {
    return ProtocolPosition(
      poolId: poolId ?? this.poolId,
      poolName: poolName ?? this.poolName,
      collateralAddress: collateralAddress ?? this.collateralAddress,
      debt: debt ?? this.debt,
      debtInUsd: debtInUsd ?? this.debtInUsd,
      collateralizationRatio:
          collateralizationRatio ?? this.collateralizationRatio,
      isLiquidatable: isLiquidatable ?? this.isLiquidatable,
      unrealizedPnl: unrealizedPnl ?? this.unrealizedPnl,
      unrealizedPnlInUsd: unrealizedPnlInUsd ?? this.unrealizedPnlInUsd,
    );
  }

  @override
  List<Object?> get props => [
    poolId,
    poolName,
    collateralAddress,
    debt,
    debtInUsd,
    collateralizationRatio,
    isLiquidatable,
    unrealizedPnl,
    unrealizedPnlInUsd,
  ];
}

/// Complete Synthetix account data for a user
class SynthetixAccount extends Equatable {
  const SynthetixAccount({
    required this.accountId,
    required this.ownerAddress,
    required this.collaterals,
    required this.positions,
    required this.totalCollateralInUsd,
    required this.totalDebtInUsd,
    required this.overallCollateralizationRatio,
    required this.createdAtBlock,
  });

  /// Unique Synthetix account ID on-chain
  final int accountId;

  /// Wallet address that owns this account
  final String ownerAddress;

  /// All collateral deposits for this account (keyed by token address)
  final Map<String, SynthetixCollateral> collaterals;

  /// All positions in pools (keyed by pool ID)
  final Map<int, ProtocolPosition> positions;

  /// Total USD value across all collateral
  final double totalCollateralInUsd;

  /// Total USD value of all debt
  final double totalDebtInUsd;

  /// Overall c-ratio across all positions
  /// collateral_value / total_debt
  final double overallCollateralizationRatio;

  /// Block number when account was created
  final int createdAtBlock;

  /// Whether account is safe from liquidation
  bool get isSafe => overallCollateralizationRatio > 1.5;

  /// Net position value (collateral - debt)
  double get netValue => totalCollateralInUsd - totalDebtInUsd;

  /// Primary collateral (usually USDC)
  SynthetixCollateral? get primaryCollateral {
    if (collaterals.isEmpty) return null;
    // Assume USDC is primary, or first collateral if USDC not present
    return collaterals.values.firstWhere(
      (c) => c.tokenSymbol == 'USDC',
      orElse: () => collaterals.values.first,
    );
  }

  /// Primary position (usually main pool)
  ProtocolPosition? get primaryPosition {
    if (positions.isEmpty) return null;
    return positions.values.first;
  }

  SynthetixAccount copyWith({
    int? accountId,
    String? ownerAddress,
    Map<String, SynthetixCollateral>? collaterals,
    Map<int, ProtocolPosition>? positions,
    double? totalCollateralInUsd,
    double? totalDebtInUsd,
    double? overallCollateralizationRatio,
    int? createdAtBlock,
  }) {
    return SynthetixAccount(
      accountId: accountId ?? this.accountId,
      ownerAddress: ownerAddress ?? this.ownerAddress,
      collaterals: collaterals ?? this.collaterals,
      positions: positions ?? this.positions,
      totalCollateralInUsd: totalCollateralInUsd ?? this.totalCollateralInUsd,
      totalDebtInUsd: totalDebtInUsd ?? this.totalDebtInUsd,
      overallCollateralizationRatio:
          overallCollateralizationRatio ?? this.overallCollateralizationRatio,
      createdAtBlock: createdAtBlock ?? this.createdAtBlock,
    );
  }

  @override
  List<Object?> get props => [
    accountId,
    ownerAddress,
    collaterals,
    positions,
    totalCollateralInUsd,
    totalDebtInUsd,
    overallCollateralizationRatio,
    createdAtBlock,
  ];
}
