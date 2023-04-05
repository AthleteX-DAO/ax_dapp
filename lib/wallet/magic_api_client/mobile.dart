import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// {@template mobile_magic_wallet_api_client}
/// Mobile client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro mobile_magic_wallet_api_client}

  @override
  EthereumChain get currentChain => throw UnsupportedError(
        'ethereumChain',
      );

  @override
  Future<dynamic> connect() {
    throw UnsupportedError(
      'connect',
    );
  }

  @override
  Future<void> getWalletInfo() {
    throw UnsupportedError(
      'getWalletInfo',
    );
  }

  @override
  Future<void> showWallet() {
    throw UnsupportedError(
      'showWallet',
    );
  }

  @override
  Future<void> requestUserInfo() {
    throw UnsupportedError(
      'requestUserInfo',
    );
  }

  @override
  Future<void> disconnect() {
    throw UnsupportedError(
      'disconnect',
    );
  }

  @override
  Future<CredentialsWithKnownAddress> requestAccount() {
    throw UnsupportedError('requestAccount');
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    throw UnsupportedError('getWalletCredentials');
  }
}
