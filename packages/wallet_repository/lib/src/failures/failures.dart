import 'package:flutter_web3/flutter_web3.dart';
import 'package:shared/shared.dart';

/// Represents a wallet failure.
class WalletFailure extends Failure {
  const WalletFailure._(super.exception, super.stackTrace);

  /// {@template metamask_unavailable_failure}
  /// Failure thrown when the `MetaMask` extension is not installed.
  /// {@endtemplate}
  factory WalletFailure.fromMetaMaskUnavailable() =>
      const MetaMaskUnavailableFailure();

  /// {@template metamask_operation_rejected_failure}
  /// Failure thrown when the `MetaMask` user rejects an operation.
  /// {@endtemplate}
  factory WalletFailure.fromOperationRejected(
    final EthereumUserRejected exception,
    final StackTrace stackTrace,
  ) =>
      MetaMaskOperationRejectedFailure(exception, stackTrace);

  /// {@template metamask_unrecognized_chain_failure}
  /// Failure thrown when the [Ethereum.walletSwitchChain] is called for a
  /// `chainId` that is not yet present on the user's wallet; in such case
  /// [Ethereum.walletAddChain] should be called.
  /// {@endtemplate}
  factory WalletFailure.fromUnrecognizedChain(
    final EthereumUnrecognizedChainException exception,
    final StackTrace stackTrace,
  ) =>
      MetaMaskUnrecognizedChainFailure(exception, stackTrace);

  /// {@template metamask_failure}
  /// Failure thrown when a generic `Ethereum` exception occurs.
  /// {@endtemplate}
  factory WalletFailure.fromMetaMask(
    final EthereumException exception,
    final StackTrace stackTrace,
  ) =>
      MetaMaskFailure(exception, stackTrace);

  /// Failure thrown when a generic error occurs.
  factory WalletFailure.fromError(
    final Object error,
    final StackTrace stackTrace,
  ) {
    if (error is WalletFailure) {
      return error;
    }
    if (error is EthereumUserRejected) {
      return WalletFailure.fromOperationRejected(error, stackTrace);
    }
    if (error is EthereumUnrecognizedChainException) {
      return WalletFailure.fromUnrecognizedChain(error, stackTrace);
    }
    if (error is EthereumException) {
      return WalletFailure.fromMetaMask(error, stackTrace);
    }
    return UnknownWalletFailure(error, stackTrace);
  }

  /// {@macro wallet_no_failure}
  static const none = WalletNoFailure._();
}

/// {@template wallet_no_failure}
/// Represents no wallet failure. Useful as default value on a bloc's state
/// class.
/// {@endtemplate}
class WalletNoFailure extends WalletFailure {
  /// {@macro wallet_no_failure}
  const WalletNoFailure._() : super._(Null, StackTrace.empty);
}

/// {@macro metamask_unavailable_failure}
class MetaMaskUnavailableFailure extends WalletFailure {
  /// {@macro metamask_unavailable_failure}
  const MetaMaskUnavailableFailure() : super._(Null, StackTrace.empty);
}

/// {@macro metamask_operation_rejected_failure}
class MetaMaskOperationRejectedFailure extends WalletFailure {
  /// {@macro metamask_operation_rejected_failure}
  const MetaMaskOperationRejectedFailure(
    EthereumUserRejected super.exception,
    super.stackTrace,
  ) : super._();
}

/// {@macro metamask_unrecognized_chain_failure}
class MetaMaskUnrecognizedChainFailure extends WalletFailure {
  /// {@macro metamask_unrecognized_chain_failure}
  const MetaMaskUnrecognizedChainFailure(
    EthereumUnrecognizedChainException super.exception,
    super.stackTrace,
  ) : super._();
}

/// {@macro metamask_failure}
class MetaMaskFailure extends WalletFailure {
  /// {@macro metamask_failure}
  const MetaMaskFailure(EthereumException super.exception, super.stackTrace)
      : super._();
}

/// {@template unknown_wallet_failure}
/// Failure thrown when an unknown error/exception occurs.
/// {@endtemplate}
class UnknownWalletFailure extends WalletFailure {
  /// {@macro unknown_wallet_failure}
  UnknownWalletFailure(super.exception, super.stackTrace) : super._();
}
