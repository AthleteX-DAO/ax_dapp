import 'package:ethereum_api/src/wallet/models/ethereum_chain.dart';
import 'package:ethereum_api/src/wallet/models/wallet_credentials.dart';
import 'package:ethereum_api/src/wallet/wallet_api_client/wallet_api_client.dart';
import 'package:shared/shared.dart';

class NativeWalletApiClient implements WalletApiClient {
  /// {@macro unsuported_native_wallet_api_client}
  NativeWalletApiClient({
    required ValueStream<Web3Client> reactiveWeb3Client,
  });

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
