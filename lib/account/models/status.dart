/// Models of all the possible states of the account page.
enum AccountViewStatus {
  initial,
  loading,
  details,
  buySell,
  deposit,
  withdraw,
  /// Synthetix wrap flow: USDC/USDT/WETH → synth (Trader path).
  wrap,
  token,
  error,
  none,
}

/// [AccountViewStatus] extensions
extension AccountViewStatusX on AccountViewStatus {
  /// returns the current status of the AccountViewStatus enum
  AccountViewStatus currentStatus() {
    switch (this) {
      case AccountViewStatus.initial:
        return AccountViewStatus.initial;
      case AccountViewStatus.loading:
        return AccountViewStatus.loading;
      case AccountViewStatus.details:
        return AccountViewStatus.details;
      case AccountViewStatus.buySell:
        return AccountViewStatus.buySell;
      case AccountViewStatus.deposit:
        return AccountViewStatus.deposit;
      case AccountViewStatus.withdraw:
        return AccountViewStatus.withdraw;
      case AccountViewStatus.wrap:
        return AccountViewStatus.wrap;
      case AccountViewStatus.token:
        return AccountViewStatus.token;
      case AccountViewStatus.none:
        return AccountViewStatus.none;
      case AccountViewStatus.error:
        return AccountViewStatus.none;
    }
  }

  bool get isUnsupported => this == AccountViewStatus.error;
}

/// Tracks the step progress of a multi-step Synthetix transaction (LP path).
///
/// idle         → no pending tx
/// approving    → ERC-20 approve is being submitted / confirmed
/// depositing   → `deposit()` tx submitted
/// delegating   → `delegateCollateral()` tx submitted
/// minting      → `mintUsd()` + `withdraw()` tx submitted
/// done         → all steps complete; axUSD landed in wallet
/// error        → one of the steps reverted
enum SynthetixTxStatus {
  idle,
  approving,
  depositing,
  delegating,
  minting,
  done,
  error,
}
