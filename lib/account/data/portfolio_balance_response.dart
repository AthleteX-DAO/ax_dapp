/// Response models for the ax-server /portfolio/balance API.

/// Synthetix V3 account state (collateral, debt, c-ratio).
class PortfolioAccountState {
  const PortfolioAccountState({
    required this.accountId,
    required this.collateralDeposited,
    required this.collateralAssigned,
    required this.collateralAvailable,
    required this.debt,
    this.cRatio,
  });

  factory PortfolioAccountState.fromJson(Map<String, dynamic> json) {
    // Synthetix returns uint256.max for c_ratio when debt is 0
    final cRatioStr = json['c_ratio'] as String?;
    BigInt? cRatio;
    if (cRatioStr != null) {
      final raw = BigInt.parse(cRatioStr);
      // uint256.max = 2^256 - 1 means "infinite" (no debt)
      if (raw < BigInt.parse('1' + '0' * 60)) {
        cRatio = raw;
      }
    }

    return PortfolioAccountState(
      accountId: BigInt.parse(json['account_id'] as String? ?? '0'),
      collateralDeposited:
          BigInt.parse(json['collateral_deposited'] as String? ?? '0'),
      collateralAssigned:
          BigInt.parse(json['collateral_assigned'] as String? ?? '0'),
      collateralAvailable:
          BigInt.parse(json['collateral_available'] as String? ?? '0'),
      debt: BigInt.parse(json['debt'] as String? ?? '0'),
      cRatio: cRatio,
    );
  }

  final BigInt accountId;
  final BigInt collateralDeposited;
  final BigInt collateralAssigned;
  final BigInt collateralAvailable;
  final BigInt debt;
  final BigInt? cRatio;
}

/// Full portfolio balance response from the server.
class PortfolioBalanceResponse {
  const PortfolioBalanceResponse({
    required this.wallet,
    required this.ax,
    required this.axusd,
    required this.usdc,
    required this.matic,
    required this.gasPriceGwei,
    required this.accounts,
  });

  factory PortfolioBalanceResponse.fromJson(Map<String, dynamic> json) {
    final accountsList = (json['accounts'] as List<dynamic>?) ?? [];
    return PortfolioBalanceResponse(
      wallet: json['wallet'] as String? ?? '',
      ax: BigInt.parse(json['ax'] as String? ?? '0'),
      axusd: BigInt.parse(json['axusd'] as String? ?? '0'),
      usdc: BigInt.parse(json['usdc'] as String? ?? '0'),
      matic: BigInt.parse(json['matic'] as String? ?? '0'),
      gasPriceGwei: (json['gas_price_gwei'] as num?)?.toDouble() ?? 0,
      accounts: accountsList
          .map(
            (e) =>
                PortfolioAccountState.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final String wallet;
  final BigInt ax;
  final BigInt axusd;
  final BigInt usdc;
  final BigInt matic;
  final double gasPriceGwei;
  final List<PortfolioAccountState> accounts;

  /// Total portfolio value in USD (rough estimate).
  /// USDC is 6 decimals, MATIC/AX/axUSD are 18 decimals.
  /// For now, USDC treated as $1, others need oracle prices.
  double get usdcBalanceUsd =>
      usdc.toDouble() / BigInt.from(10).pow(6).toDouble();

  double get maticBalance =>
      matic.toDouble() / BigInt.from(10).pow(18).toDouble();

  double get axBalance =>
      ax.toDouble() / BigInt.from(10).pow(18).toDouble();

  /// Primary account (first in list) or null.
  PortfolioAccountState? get primaryAccount =>
      accounts.isNotEmpty ? accounts.first : null;
}
