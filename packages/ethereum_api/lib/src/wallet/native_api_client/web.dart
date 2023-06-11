import 'package:ethereum_api/src/wallet/failures/failures.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:shared/shared.dart';
import 'package:web3_browser/web3_browser.dart' as web3_browser;

/// {@template native_wallet_api_client}
/// Web only client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}

class NativeWalletApiClient implements WalletApiClient {
  NativeWalletApiClient({
    required ValueStream<Web3Client> reactiveWeb3Client,
  }) : _reactiveWeb3Client = reactiveWeb3Client;

  final ValueStream<Web3Client> _reactiveWeb3Client;
  Web3Client get _web3Client => _reactiveWeb3Client.value;

  @override
  Future<void> addChain(EthereumChain chain) {
    // TODO: implement addChain
    throw UnimplementedError();
  }

  @override
  void addChainChangedListener() {
    // TODO: implement addChainChangedListener
  }

  @override
  Future<void> addToken(
      {required String tokenAddress, required String tokenImageUrl}) {
    // TODO: implement addToken
    throw UnimplementedError();
  }

  @override
  // TODO: implement chainChanges
  Stream<EthereumChain> get chainChanges => throw UnimplementedError();

  @override
  // TODO: implement currentChain
  EthereumChain get currentChain => throw UnimplementedError();

  @override
  Future<BigInt> getDecimals(String tokenAddress) {
    // TODO: implement getDecimals
    throw UnimplementedError();
  }

  @override
  Future<double> getGasPrice() async {
    // TODO: implement getGasPrice

    final gasprice = await _web3Client.getGasPrice() as double;

    return gasprice;
  }

  @override
  Future<BigInt> getRawTokenBalance(
      {required String tokenAddress, required String walletAddress}) {
    // TODO: implement getRawTokenBalance
    throw UnimplementedError();
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    // TODO: implement getWalletCredentials

    throw UnimplementedError();
  }

  @override
  void removeChainChangedListener() {
    // TODO: implement removeChainChangedListener
  }

  @override
  Future<void> switchChain(EthereumChain chain) {
    // TODO: implement switchChain
    throw UnimplementedError();
  }

  @override
  Future<void> syncChain(EthereumChain chain) {
    // TODO: implement syncChain
    throw UnimplementedError();
  }
}
