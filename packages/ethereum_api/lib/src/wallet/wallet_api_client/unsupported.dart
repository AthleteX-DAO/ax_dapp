import 'package:ethereum_api/src/wallet/models/ethereum_chain.dart';
import 'package:ethereum_api/src/wallet/models/wallet_credentials.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';

/// Mobile client that manages the wallet API(i.e. MetaMask).
class EthereumWalletApiClient implements WalletApiClient {
  @override
  Stream<EthereumChain> get ethereumChainChanges => throw UnsupportedError(
        'ethereumChainChanges not supported on the current platform',
      );

  @override
  EthereumChain get ethereumChain => throw UnsupportedError(
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
}
