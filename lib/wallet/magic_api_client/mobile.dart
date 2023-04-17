import 'package:ax_dapp/wallet/magic_api_client/magic_wallet_api_client.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

/// {@template mobile_magic_wallet_api_client}
/// Mobile client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
class MagicWalletApiClient extends MagicApiClient {
  /// {@macro mobile_magic_wallet_api_client}

  @override
  EthereumChain get currentChain => throw UnsupportedError(
        'ethereumChain',
      );

  @override
  Future<dynamic> connect() {
    throw UnsupportedError(
      'connect',
    );
  }

  @override
  Future<void> getWalletInfo() {
    throw UnsupportedError(
      'getWalletInfo',
    );
  }

  @override
  Future<void> showWallet() {
    throw UnsupportedError(
      'showWallet',
    );
  }

  @override
  Future<void> requestUserInfo() {
    throw UnsupportedError(
      'requestUserInfo',
    );
  }

  @override
  Future<void> disconnect() {
    throw UnsupportedError(
      'disconnect',
    );
  }

  @override
  Future<CredentialsWithKnownAddress> requestAccount() {
    throw UnsupportedError('requestAccount');
  }

  @override
  Future<WalletCredentials> getWalletCredentials() {
    throw UnsupportedError('getWalletCredentials');
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
  Future<void> addToken({required String tokenAddress, required String tokenImageUrl}) {
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
  Future<BigInt> getRawTokenBalance({required String tokenAddress, required String walletAddress}) {
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
