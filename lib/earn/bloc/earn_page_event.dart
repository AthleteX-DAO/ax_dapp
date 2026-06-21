part of 'earn_page_bloc.dart';

abstract class EarnPageEvent extends Equatable {
  const EarnPageEvent();
}

/// Start listening to AppData stream for chain/wallet changes.
class WatchAppDataChangesStarted extends EarnPageEvent {
  const WatchAppDataChangesStarted();

  @override
  List<Object> get props => [];
}

/// Expand a specific tile and collapse others
class ExpandTile extends EarnPageEvent {
  const ExpandTile(this.tileType);
  final TileType tileType;

  @override
  List<Object> get props => [tileType];
}

/// Collapse all tiles
class CollapseAllTiles extends EarnPageEvent {
  const CollapseAllTiles();

  @override
  List<Object> get props => [];
}

/// Update amount input (with debouncing)
class UpdateAmount extends EarnPageEvent {
  const UpdateAmount(this.amount);
  final double amount;

  @override
  List<Object> get props => [amount];
}

/// Update leverage slider
class UpdateLeverage extends EarnPageEvent {
  const UpdateLeverage(this.leverage);
  final double leverage; // 1.0 to 2.0

  @override
  List<Object> get props => [leverage];
}

/// Refresh collateral ratio immediately (e.g., on button hover)
class RefreshCollateralRatioNow extends EarnPageEvent {
  const RefreshCollateralRatioNow();

  @override
  List<Object> get props => [];
}

/// Submit deposit form and start transaction
class SubmitDepositForm extends EarnPageEvent {
  const SubmitDepositForm({
    required this.vaultSymbol,
    required this.amount,
    this.leverage = 1.0,
  });
  final String vaultSymbol;
  final double amount;
  final double leverage;

  @override
  List<Object> get props => [vaultSymbol, amount, leverage];
}

/// Submit withdraw form
class SubmitWithdrawForm extends EarnPageEvent {
  const SubmitWithdrawForm({
    required this.vaultSymbol,
    required this.amount,
  });
  final String vaultSymbol;
  final double amount;

  @override
  List<Object> get props => [vaultSymbol, amount];
}

/// Submit mint stablecoins form
class SubmitMintForm extends EarnPageEvent {
  const SubmitMintForm({
    required this.amount,
    required this.collateralAddress,
  });
  final double amount;
  final String collateralAddress;

  @override
  List<Object> get props => [amount, collateralAddress];
}

/// Submit burn (repay) stablecoins form
class SubmitBurnForm extends EarnPageEvent {
  const SubmitBurnForm({
    required this.amount,
    required this.collateralAddress,
  });
  final double amount;
  final String collateralAddress;

  @override
  List<Object> get props => [amount, collateralAddress];
}

/// Poll transaction receipt for confirmation
class PollTransaction extends EarnPageEvent {
  const PollTransaction(this.txHash);
  final String txHash;

  @override
  List<Object> get props => [txHash];
}

/// Transaction confirmed (receipt received)
class TransactionConfirmed extends EarnPageEvent {
  const TransactionConfirmed();

  @override
  List<Object> get props => [];
}

/// Transaction failed
class TransactionFailed extends EarnPageEvent {
  const TransactionFailed(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

/// Close transaction modal
class CloseTransactionModal extends EarnPageEvent {
  const CloseTransactionModal();

  @override
  List<Object> get props => [];
}

/// Fetch platform TVL
class FetchPlatformTVL extends EarnPageEvent {
  const FetchPlatformTVL();

  @override
  List<Object> get props => [];
}

/// Internal event dispatched by the transaction polling timer.
/// Must use add() from Timer callbacks, never emit() directly.
class _TransactionPollResult extends EarnPageEvent {
  const _TransactionPollResult({required this.success, this.error});
  final bool success;
  final String? error;

  @override
  List<Object> get props => [success, error ?? ''];
}

/// Internal event dispatched by the C-ratio debounce timer.
class _CollateralRatioResult extends EarnPageEvent {
  const _CollateralRatioResult({required this.ratio});
  final double ratio;

  @override
  List<Object> get props => [ratio];
}

enum TileType { earnSimple, provideLiquidity, borrowStablecoins }
