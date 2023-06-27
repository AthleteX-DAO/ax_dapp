import 'dart:js_interop';

import 'package:ethereum_api/src/wallet/magic_api_client/javascript_calls/magic.dart';
import 'package:ethereum_api/src/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';

/// {@template unsupported_magic_wallet_api_client}
/// Unsupported implementation of [MagicWalletApiClient]
/// {@endtemplate}
class MagicWalletApiClient implements MagicApiClient {
  /// {@macro unsupported_magic_wallet_api_client}
  MagicWalletApiClient({
    required MagicSDK magicSDK,
    required ValueStream<Web3Client> reactiveWeb3Client,
  }) : _reactiveWeb3Client = reactiveWeb3Client;

  final ValueStream<Web3Client> _reactiveWeb3Client;
  Web3Client get _web3Client => _reactiveWeb3Client.isUndefinedOrNull
      ? throw Exception(
          'Unable to retrieve the web3Client',
        )
      : _reactiveWeb3Client.value;

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

  @override
  Future<void> addChain(EthereumChain chain) {
    // TODO: implement addChain
    throw UnimplementedError(
      'addChain is not implemented on the current platform',
    );
  }

  @override
  void addChainChangedListener() {
    // TODO: implement addChainChangedListener
    throw UnsupportedError(
      'addChainChangedListener is not supported on the current platform',
    );
  }

  @override
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) {
    // TODO: implement addToken
    throw UnimplementedError(
      'addToken is not implemented on the current platform',
    );
  }

  @override
  // TODO: implement chainChanges
  Stream<EthereumChain> get chainChanges => throw UnimplementedError(
        'chainChanges are not implemented on the current platform',
      );

  @override
  Future<BigInt> getDecimals(String tokenAddress) {
    // TODO: implement getDecimals
    throw UnimplementedError(
      'getDecimals is not implemented on the current platform',
    );
  }

  @override
  Future<BigInt> getGasPrice() {
    // TODO: implement getGasPrice
    throw UnimplementedError(
      'getGasPrice is not implemented on the current platform',
    );
  }

  @override
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  }) {
    // TODO: implement getRawTokenBalance
    throw UnimplementedError(
      'getRawTokenBalance is not implemented on the current platform',
    );
  }

  @override
  void removeChainChangedListener() {
    // TODO: implement removeChainChangedListener
    throw UnimplementedError(
      'removechainChangedlistener is not implemented on the current platform',
    );
  }

  @override
  Future<void> switchChain(EthereumChain chain) {
    // TODO: implement switchChain
    throw UnimplementedError(
      'switchChain is not implemented on the current platform',
    );
  }

  @override
  Future<void> syncChain(EthereumChain chain) {
    throw UnimplementedError(
      'syncChain is not implemented on the current platform',
    );
  }
}
