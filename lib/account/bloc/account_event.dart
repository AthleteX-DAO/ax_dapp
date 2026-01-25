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
  const AccountWithdrawViewRequested();
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
