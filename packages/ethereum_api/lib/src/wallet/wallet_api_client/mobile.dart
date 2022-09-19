import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:shared/shared.dart';

/// {@template mobile_wallet_api_client}
/// Mobile client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}
class EthereumWalletApiClient implements WalletApiClient {
  /// {@macro mobile_wallet_api_client}
  EthereumWalletApiClient({
    required ValueStream<Web3Client> reactiveWeb3Client,
  }) : _reactiveWeb3Client = reactiveWeb3Client;

  // ignore: unused_field
  final ValueStream<Web3Client> _reactiveWeb3Client;

  @override
  Stream<EthereumChain> get chainChanges =>
      throw UnimplementedError('ethereumChainChanges');

  @override
  EthereumChain get currentChain => throw UnimplementedError('ethereumChain');

  @override
  Future<void> addChain(EthereumChain ethereumChain) {
    throw UnimplementedError('addChain');
  }

  @override
  Future<void> switchChain(EthereumChain ethereumChain) {
    throw UnimplementedError('switchChain');
  }

  @override
  Future<void> syncChain(EthereumChain ethereumChain) {
    throw UnimplementedError('switchChain');
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    throw UnimplementedError('getWalletCredentials');
  }

  @override
  void addChainChangedListener() =>
      throw UnimplementedError('addChainChangedListener');

  @override
  void removeChainChangedListener() =>
      throw UnimplementedError('removeChainChangedListener');

  @override
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  }) {
    throw UnimplementedError('addToken');
  }

  @override
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  }) {
    throw UnimplementedError('getRawTokenBalance');
  }

  @override
  Future<double> getGasPrice() {
    throw UnimplementedError('getGasPrice');
  }
}
