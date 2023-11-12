///Models of all the possible states of the account page
enum AccountViewStatus {
  initial,
  loading,
  details,
  buySell,
  deposit,
  withdraw,
  token,
  error,
  none
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
