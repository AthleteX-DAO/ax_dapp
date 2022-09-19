import 'package:ethereum_api/src/wallet/models/models.dart';

/// {@template wallet_api_client}
/// Client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}
abstract class WalletApiClient {
  /// {@macro wallet_api_client}

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get chainChanges;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get currentChain;

  /// Adds the specified [chain] to user's wallet.
  Future<void> addChain(EthereumChain chain);

  /// Switches the currently used chain.
  Future<void> switchChain(EthereumChain chain);

  /// Sync the current used chain
  Future<void> syncChain(EthereumChain chain);

  /// Asks the user to select an account and give your application access to it.
  /// Returns the [WalletCredentials] for the connected account.
  Future<WalletCredentials> getWalletCredentials();

  /// Adds `onChainChanged` listener.
  void addChainChangedListener();

  /// Removes `onChainChanged` listener.
  void removeChainChangedListener();

  /// Adds the token with the given [tokenAddress] and [tokenImageUrl] to
  /// user's wallet.
  Future<void> addToken({
    required String tokenAddress,
    required String tokenImageUrl,
  });

  /// Returns the amount of tokens with [tokenAddress] owned by the wallet
  /// identified by [walletAddress].
  ///
  /// Defaults to [BigInt.zero] on error.
  Future<BigInt> getRawTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  });

  /// Returns the amount typically needed to pay for one unit of gas(in gwei).
  Future<double> getGasPrice();
}
