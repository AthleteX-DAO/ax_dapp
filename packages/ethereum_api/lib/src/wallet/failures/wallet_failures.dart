part of 'wallet_failure.dart';

/// {@template wallet_no_failure}
/// Represents no wallet failure. Useful as default value on a bloc's state
/// class.
/// {@endtemplate}
class WalletNoFailure extends WalletFailure {
  /// {@macro wallet_no_failure}
  const WalletNoFailure._() : super._(Null, StackTrace.empty);
}

/// {@macro wallet_unavailable_failure}
class WalletUnavailableFailure extends WalletFailure {
  /// {@macro wallet_unavailable_failure}
  const WalletUnavailableFailure() : super._(Null, StackTrace.empty);

  @override
  bool get needsReconnecting => true;
}

/// {@macro wallet_operation_rejected_failure}
class WalletOperationRejectedFailure extends WalletFailure {
  /// {@macro wallet_operation_rejected_failure}
  const WalletOperationRejectedFailure(
    super.exception,
    super.stackTrace,
  ) : super._();
}

/// {@macro wallet_unrecognized_chain_failure}
class WalletUnrecognizedChainFailure extends WalletFailure {
  /// {@macro wallet_unrecognized_chain_failure}
  const WalletUnrecognizedChainFailure(
    super.exception,
    super.stackTrace,
  ) : super._();

  /// Although this is caught and handled gracefully, resulting in adding the
  /// new chain.
  @override
  bool get needsReconnecting => true;
}

/// {@macro ethereum_wallet_failure}
class EthereumWalletFailure extends WalletFailure {
  /// {@macro ethereum_wallet_failure}
  const EthereumWalletFailure(
    EthereumException super.exception,
    super.stackTrace,
  ) : super._();

  @override
  bool get needsReconnecting => true;
}

/// {@template unknown_wallet_failure}
/// Failure thrown when an unknown error/exception occurs.
/// {@endtemplate}
class UnknownWalletFailure extends WalletFailure {
  /// {@macro unknown_wallet_failure}
  UnknownWalletFailure(super.exception, super.stackTrace) : super._();

  @override
  bool get needsReconnecting => true;
}
