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
