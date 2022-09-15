// ignore_for_file: avoid_unused_constructor_parameters

import 'package:ethereum_api/src/wallet/models/ethereum_chain.dart';
import 'package:ethereum_api/src/wallet/models/wallet_credentials.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:shared/shared.dart';

/// {@template unsupported_wallet_api_client}
/// Unsupported implementation of [WalletApiClient]
/// {@endtemplate}
class EthereumWalletApiClient implements WalletApiClient {
  /// {@macro unsupported_wallet_api_client}
  EthereumWalletApiClient({
    required ValueStream<Web3Client> reactiveWeb3Client,
  });

  @override
  Stream<EthereumChain> get chainChanges => throw UnsupportedError(
        'ethereumChainChanges not supported on the current platform',
      );

  @override
  EthereumChain get currentChain => throw UnsupportedError(
        'ethereumChain not supported on the current platform',
      );

  @override
  Future<void> addChain(EthereumChain ethereumChain) {
    throw UnsupportedError('addChain not supported on the current platform');
  }

  @override
  Future<void> switchChain(EthereumChain ethereumChain) {
    throw UnsupportedError(
      'switchChain not supported on the current platform',
    );
  }

  @override
  Future<void> syncChain(EthereumChain ethereumChain) {
    throw UnsupportedError(
      'syncChain not supported on the current platform',
    );
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    throw UnsupportedError(
      'getWalletCredentials not supported on the current platform',
    );
  }

  @override
  void addChainChangedListener() => throw UnsupportedError(
        'addChainChangedListener not supported on the current platform',
      );

  @override
  void removeChainChangedListener() => throw UnsupportedError(
        'removeChainChangedListener not supported on the current platform',
      );

  @override
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) {
    throw UnsupportedError('addToken not supported on the current platform');
  }

  @override
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  }) {
    throw UnsupportedError(
      'getRawTokenBalance not supported on the current platform',
    );
  }

  @override
  Future<double> getGasPrice() {
    throw UnsupportedError('getGasPrice not supported on the current platform');
  }
}
