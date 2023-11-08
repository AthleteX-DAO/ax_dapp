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
