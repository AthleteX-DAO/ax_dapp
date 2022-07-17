// ignore_for_file: type_annotate_public_apis
// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: inference_failure_on_uninitialized_variable

import 'package:ax_dapp/service/controller/create_wallet/create_wallet.dart';

/// Thrown when MetaMask extension is not installed.
class MetaMaskUnavailableFailure implements Exception {
  const MetaMaskUnavailableFailure();
}

abstract class DappWallet {
  static DappWallet? _connectedWalletInstance;
  var activeChainId;
  var publicAddress;
  var credentials;
  var networkID;
  var mnemonic;
  var seedHex;
  var client;

  static DappWallet? get instance {
    return _connectedWalletInstance ??= newWallet();
  }

  Future<dynamic> connect();
}
