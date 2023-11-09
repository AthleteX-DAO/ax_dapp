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

class SwitchTokenRequested extends AccountEvent {
  const SwitchTokenRequested({required this.tokenAddress});
  final String tokenAddress;

  @override
  List<Object?> get props => [tokenAddress];
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
