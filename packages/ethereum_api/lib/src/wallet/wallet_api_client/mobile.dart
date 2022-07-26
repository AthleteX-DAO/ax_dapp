import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';

/// Mobile client that manages the wallet API(i.e. MetaMask).
class EthereumWalletApiClient implements WalletApiClient {
  @override
  Stream<EthereumChain> get ethereumChainChanges =>
      throw UnimplementedError('ethereumChainChanges');

  @override
  EthereumChain get ethereumChain => throw UnimplementedError('ethereumChain');

  @override
  Future<void> addChain(EthereumChain ethereumChain) {
    throw UnimplementedError('addChain');
  }

  @override
  Future<void> switchChain(EthereumChain ethereumChain) {
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
}
