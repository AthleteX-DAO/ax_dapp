import 'createWallet.dart';

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
    if (_connectedWalletInstance == null) {
      _connectedWalletInstance = newWallet();
    }

    return _connectedWalletInstance;
  }

  Future<dynamic> connect();
}
