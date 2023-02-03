import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';

/// {@template mobile_magic_wallet_api_client}
/// Mobile client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro mobile_magic_wallet_api_client}
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
}
