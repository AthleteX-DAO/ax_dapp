import 'dart:js_util';

import 'package:ax_dapp/wallet/javascript_calls/magic.dart';
import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:ethereum_api/tokens_api.dart';

/// {@template magic_wallet_api_client}
/// Web only client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro magic_wallet_api_client}
  MagicApiClient({required MagicSDK magicSDK}) : _magicSDK = magicSDK;

  final MagicSDK _magicSDK;

  @override
  EthereumChain get currentChain => EthereumChain.polygonMainnet;

  /// Allows the user to connect to a 'Magic' wallet.
  ///
  /// Returns the hexadecimal representation of the wallet address.
  ///
  /// Throws:
  @override
  Future<dynamic> connect() async {
    try {
      final address = promiseToFuture<String>(_magicSDK.connect());
      return address;
    } catch (_) {}
  }

  /// Allows the user to retrieve information about their wallet.
  ///
  /// Throws:
  @override
  Future<void> getWalletInfo() async {
    try {
      await _magicSDK.getWalletInfo();
    } catch (_) {}
  }

  /// Allows the user to show their 'Magic' wallet.
  ///
  /// Throws:
  @override
  Future<void> showWallet() async {
    try {
      await _magicSDK.showWallet();
    } catch (_) {}
  }

  /// Allows the user to send their information upon request
  ///
  /// Returns a string representation of the email address
  /// that is associated with the 'Magic' wallet
  ///
  /// Throws:
  @override
  Future<void> requestUserInfo() async {
    try {
      await _magicSDK.requestUserInfo();
    } catch (_) {}
  }

  /// Disconnects the user from their 'Magic' wallet.
  ///
  /// Throws:
  @override
  Future<void> disconnect() async {
    try {
      await _magicSDK.disconnect();
    } catch (_) {}
  }
}
