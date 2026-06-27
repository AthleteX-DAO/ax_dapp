part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class AccountDetailsViewRequested extends AccountEvent {
  const AccountDetailsViewRequested();
}

class AccountWithdrawViewRequested extends AccountEvent {
  const AccountWithdrawViewRequested({this.initialTabIndex = 0});
  final int initialTabIndex;

  @override
  List<Object?> get props => [initialTabIndex];
}

class AccountDepositViewRequested extends AccountEvent {
  const AccountDepositViewRequested();
}

class AccountBuyAndSellViewRequested extends AccountEvent {
  const AccountBuyAndSellViewRequested();
}

class AccountTokenViewRequested extends AccountEvent {
  const AccountTokenViewRequested({required this.token});

  final Token token;

  @override
  List<Object?> get props => [token];
}

class AccountWithdrawConfirm extends AccountEvent {
  const AccountWithdrawConfirm();
}

class WatchAppDataChangesStarted extends AccountEvent {
  const WatchAppDataChangesStarted();
}

class FetchTokenInfoRequested extends AccountEvent {
  const FetchTokenInfoRequested();
}

class FetchVaultSummariesRequested extends AccountEvent {
  const FetchVaultSummariesRequested();
}

class SelectTokenRequested extends AccountEvent {
  const SelectTokenRequested({required this.token});
  final Token token;

  @override
  List<Object?> get props => [token];
}

class UpdateRecipentAddressRequested extends AccountEvent {
  const UpdateRecipentAddressRequested({required this.recipentAddress});

  final String recipentAddress;

  @override
  List<Object?> get props => [recipentAddress];
}

class UpdateBalanceRequested extends AccountEvent {
  const UpdateBalanceRequested({required this.tokenAddress});
  final String tokenAddress;

  @override
  List<Object?> get props => [tokenAddress];
}

class SelectedAccountAssetsChanged extends AccountEvent {
  const SelectedAccountAssetsChanged({
    required this.selectedAssets,
  });

  final AccountAssets selectedAssets;

  @override
  List<Object?> get props => [selectedAssets];
}

class UpdateWithdrawInput extends AccountEvent {
  const UpdateWithdrawInput({required this.tokenAmountInput});

  final double tokenAmountInput;

  @override
  List<Object?> get props => [tokenAmountInput];
}

class WithdrawChainSelected extends AccountEvent {
  const WithdrawChainSelected({required this.chain});

  final EthereumChain chain;

  @override
  List<Object?> get props => [chain];
}

// Synthetix V3 account events

class FetchSynthetixAccountRequested extends AccountEvent {
  const FetchSynthetixAccountRequested();
}

class CreateSynthetixAccountRequested extends AccountEvent {
  const CreateSynthetixAccountRequested();
}

class DepositSynthetixCollateralRequested extends AccountEvent {
  const DepositSynthetixCollateralRequested({
    required this.collateralAddress,
    required this.amount,
  });

  final String collateralAddress;
  final BigInt amount;

  @override
  List<Object?> get props => [collateralAddress, amount];
}

class WithdrawSynthetixCollateralRequested extends AccountEvent {
  const WithdrawSynthetixCollateralRequested({
    required this.collateralAddress,
    required this.amount,
  });

  final String collateralAddress;
  final BigInt amount;

  @override
  List<Object?> get props => [collateralAddress, amount];
}

class DelegateSynthetixCollateralRequested extends AccountEvent {
  const DelegateSynthetixCollateralRequested({
    required this.poolId,
    required this.collateralAddress,
    required this.amount,
    this.leverage,
  });

  final int poolId;
  final String collateralAddress;
  final BigInt amount;
  final BigInt? leverage;

  @override
  List<Object?> get props => [poolId, collateralAddress, amount, leverage];
}

class UndelegateSynthetixCollateralRequested extends AccountEvent {
  const UndelegateSynthetixCollateralRequested({
    required this.poolId,
    required this.collateralAddress,
    required this.amount,
  });

  final int poolId;
  final String collateralAddress;
  final BigInt amount;

  @override
  List<Object?> get props => [poolId, collateralAddress, amount];
}

/// Mint axUSD against delegated collateral, then withdraw to wallet.
///
/// [sliderValue] is 0.0–1.0 representing fraction of max mintable amount.
class MintAxUsdRequested extends AccountEvent {
  const MintAxUsdRequested({
    required this.collateralAddress,
    required this.sliderValue,
  });

  final String collateralAddress;

  /// Fraction of the safe-maximum mintable axUSD (0.0–1.0).
  /// 0.5 means "mint 50% of the safe maximum" (c-ratio stays at ~5x).
  final double sliderValue;

  @override
  List<Object?> get props => [collateralAddress, sliderValue];
}

/// Update the mint slider position without triggering a transaction.
class MintSliderChanged extends AccountEvent {
  const MintSliderChanged(this.value);
  final double value;
  @override
  List<Object?> get props => [value];
}

/// Wrap a real token (USDC/USDT/WETH) into its synth equivalent.
///
/// Calls SpotMarket `wrap(marketId, amount, minAmountReceived)`.
/// [slippageBps] is the maximum acceptable slippage in basis points
/// (e.g. 50 = 0.5%). Defaults to 50 bps.
class WrapCollateralRequested extends AccountEvent {
  const WrapCollateralRequested({
    required this.marketId,
    required this.collateralAddress,
    required this.amount,
    this.slippageBps = 50,
  });

  final int marketId;
  final String collateralAddress;
  final BigInt amount;

  /// Max slippage in basis points (1 bps = 0.01%). Default: 50 bps (0.5%).
  final int slippageBps;

  @override
  List<Object?> get props => [marketId, collateralAddress, amount, slippageBps];
}

/// Switch the active collateral type shown in deposit/wrap flows.
class CollateralTypeSelected extends AccountEvent {
  const CollateralTypeSelected(this.collateral);
  final CollateralInfo collateral;
  @override
  List<Object?> get props => [collateral];
}

/// Navigate to the wrap flow screen.
class AccountWrapViewRequested extends AccountEvent {
  const AccountWrapViewRequested();
}
