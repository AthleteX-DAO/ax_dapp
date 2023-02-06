import 'dart:js_util';

import 'package:ax_dapp/wallet/javascript_calls/magic.dart';
import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';

/// {@template magic_wallet_api_client}
/// Web only client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicApiClient implements MagicWalletApiClient {
  /// {@macro magic_wallet_api_client}
  MagicApiClient({required MagicSDK magicSDK}) : _magicSDK = magicSDK;

  final MagicSDK _magicSDK;
  @override
  Future<dynamic> connect() async {
    final address = promiseToFuture<String>(_magicSDK.connect());
    return address;
  }

  @override
  Future<void> getWalletInfo() async {
    await _magicSDK.getWalletInfo();
  }

  @override
  Future<void> showWallet() async {
    await _magicSDK.showWallet();
  }

  @override
  Future<void> requestUserInfo() async {
    await _magicSDK.requestUserInfo();
  }

  @override
  Future<void> disconnect() async {
    await _magicSDK.disconnect();
  }
}
