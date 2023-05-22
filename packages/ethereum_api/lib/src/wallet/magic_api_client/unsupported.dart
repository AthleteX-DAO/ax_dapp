import 'package:ethereum_api/src/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:web3dart/src/credentials/credentials.dart';

/// {@template unsupported_magic_wallet_api_client}
/// Unsupported implementation of [MagicWalletApiClient]
/// {@endtemplate}
class MagicWalletApiClient implements MagicApiClient {
  /// {@macro unsupported_magic_wallet_api_client}

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
  Future<BigInt> getDecimals(String tokenAddress) {
    // TODO: implement getDecimals
    throw UnimplementedError();
  }

  @override
  Future<double> getGasPrice() {
    // TODO: implement getGasPrice
    throw UnimplementedError();
  }

  @override
  Future<BigInt> getRawTokenBalance(
      {required String tokenAddress, required String walletAddress}) {
    // TODO: implement getRawTokenBalance
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
