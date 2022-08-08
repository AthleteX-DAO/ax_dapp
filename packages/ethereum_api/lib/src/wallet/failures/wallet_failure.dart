import 'package:flutter_web3/flutter_web3.dart';
import 'package:shared/shared.dart';

part 'wallet_failures.dart';

/// Represents a wallet failure.
class WalletFailure extends Failure {
  const WalletFailure._(super.exception, super.stackTrace);

  /// {@template wallet_unavailable_failure}
  /// Failure thrown when the `MetaMask` extension is not installed.
  /// {@endtemplate}
  factory WalletFailure.fromWalletUnavailable() =>
      const WalletUnavailableFailure();

  /// {@template wallet_operation_rejected_failure}
  /// Failure thrown when the `MetaMask` user rejects an operation.
  /// {@endtemplate}
  factory WalletFailure.fromOperationRejected(
    final Object exception,
    final StackTrace stackTrace,
  ) =>
      WalletOperationRejectedFailure(exception, stackTrace);

  /// {@template wallet_unsuccessful_operation_failure}
  /// Failure thrown to signal an unsuccessful `MetaMask` operation.
  /// {@endtemplate}
  factory WalletFailure.fromUnsuccessfulOperation() =>
      WalletUnsuccessfulOperationFailure();

  /// {@template wallet_unrecognized_chain_failure}
  /// Failure thrown when the [Ethereum.walletSwitchChain] is called for a
  /// `chainId` that is not yet present on the user's wallet; in such case
  /// [Ethereum.walletAddChain] should be called.
  /// {@endtemplate}
  factory WalletFailure.fromUnrecognizedChain(
    final Object exception,
    final StackTrace stackTrace,
  ) =>
      WalletUnrecognizedChainFailure(exception, stackTrace);

  /// {@template ethereum_wallet_failure}
  /// Failure thrown when a generic `Ethereum` exception occurs.
  /// {@endtemplate}
  factory WalletFailure.fromEthereum(
    final EthereumException exception,
    final StackTrace stackTrace,
  ) {
    final code = exception.code;
    if (code == 4902) {
      return WalletFailure.fromUnrecognizedChain(exception, stackTrace);
    } else if (code == 4001) {
      return WalletFailure.fromOperationRejected(exception, stackTrace);
    }
    return EthereumWalletFailure(exception, stackTrace);
  }

  /// Failure thrown when dealing with the `web3_browser`'s `Ethereum`.
  factory WalletFailure.fromBrowserEthereum(
    final Object error,
    final StackTrace stackTrace,
  ) {
    // `web3_browser` returns `LegacyJavaScriptObject`
    final maybeJsError = error as dynamic;
    // ignore: avoid_dynamic_calls
    final maybeJsErrorCode = maybeJsError?.code;
    if (maybeJsErrorCode == 4001) {
      return WalletFailure.fromOperationRejected(error, stackTrace);
    }
    return UnknownWalletFailure(error, stackTrace);
  }

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
      return WalletFailure.fromEthereum(error, stackTrace);
    }
    // web3_browser returns `LegacyJavaScriptObject`
    final maybeJsError = error as dynamic;
    // ignore: avoid_dynamic_calls
    final maybeJsErrorCode = maybeJsError?.code;
    if (maybeJsErrorCode == 4001) {
      return WalletFailure.fromOperationRejected(error, stackTrace);
    }
    return UnknownWalletFailure(error, stackTrace);
  }

  /// {@macro wallet_no_failure}
  static const none = WalletNoFailure._();
}
