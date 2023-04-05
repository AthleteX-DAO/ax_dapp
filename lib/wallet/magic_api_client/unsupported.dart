import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:web3dart/src/credentials/credentials.dart';

/// {@template unsupported_magic_wallet_api_client}
/// Unsupported implementation of [MagicWalletApiClient]
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro unsupported_magic_wallet_api_client}

  @override
  EthereumChain get currentChain => throw UnsupportedError(
        'ethereumChain not supported on the current platform',
      );

  @override
  Future<dynamic> connect() {
    throw UnsupportedError(
      'connect not supported on the current platform',
    );
  }

  @override
  Future<void> getWalletInfo() {
    throw UnsupportedError(
      'getWalletInfo not supported on the current platform',
    );
  }

  @override
  Future<void> showWallet() {
    throw UnsupportedError(
      'showWallet not supported on the current platform',
    );
  }

  @override
  Future<void> requestUserInfo() {
    throw UnsupportedError(
      'requestUserInfo not supported on the current platform',
    );
  }

  @override
  Future<void> disconnect() {
    throw UnsupportedError(
      'disconnect not supported on the current platform',
    );
  }

  @override
  Future<CredentialsWithKnownAddress> requestAccount() {
    throw UnsupportedError(
      'requestAccount not supported on the current platform',
    );
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    throw UnsupportedError(
      'getWalletCredentials not supported on the current platform',
    );
  }
}
