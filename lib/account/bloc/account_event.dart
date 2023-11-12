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

class MaxWithdrawTap extends AccountEvent {
  const MaxWithdrawTap({required this.tokenBalance});

  final double tokenBalance;

  @override
  List<Object?> get props => [tokenBalance];
}
