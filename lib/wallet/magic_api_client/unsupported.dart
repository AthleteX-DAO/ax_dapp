import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';

/// {@template unsupported_magic_wallet_api_client}
/// Unsupported implementation of [MagicWalletApiClient]
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro unsupported_magic_wallet_api_client}
  @override
  Future<dynamic> connect() {
    throw UnsupportedError(
      'magic connect not supported on the current platform',
    );
  }

  @override
  Future<void> getWalletInfo() {
    throw UnsupportedError(
      'get wallet info not supported on the current platform',
    );
  }

  @override
  Future<void> showWallet() {
    throw UnsupportedError(
      'show wallet not supported on the current platform',
    );
  }

  @override
  Future<void> requestUserInfo() {
    throw UnsupportedError(
      'request user info not supported on the current platform',
    );
  }

  @override
  Future<void> disconnect() {
    throw UnsupportedError(
      'disconnect operation not supported on the current platform',
    );
  }
}
