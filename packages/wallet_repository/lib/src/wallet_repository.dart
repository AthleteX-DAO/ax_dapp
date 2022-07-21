import 'package:flutter_web3/flutter_web3.dart';
import 'package:wallet_repository/src/models/models.dart';

/// {@template wallet_repository}
/// Repository that manages the wallet domain.
/// {@endtemplate}
class WalletRepository {
  /// {@macro wallet_repository}
  WalletRepository({Ethereum? ethereum})
      : _ethereum = ethereum ?? Ethereum.provider;

  final Ethereum? _ethereum;

  /// Allows the user to connect to a `MetaMask` wallet.
  Future<void> connectWallet() {
    throw UnimplementedError();
  }

  /// Switches the currently used chain.
  Future<void> switchChain(EthereumChain ethereumChain) async {
    _checkEthereumAvailability();
    try {
      await _ethereum!.walletSwitchChain(ethereumChain.chainId);
    } catch (e) {
      //
    }
  }

  void _checkEthereumAvailability() {
    if (_ethereum == null) {
      throw UnimplementedError();
    }
  }
}
