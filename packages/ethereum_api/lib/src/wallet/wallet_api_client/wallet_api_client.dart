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

  /// Returns an aproximate balance for the token with the given [tokenAddress],
  /// on the wallet identified by [walletAddress]. It returns a balance of
  /// `0.0` when any error occurs.
  ///
  /// **WARNING**: Due to rounding errors, the returned balance is not
  /// reliable, especially for larger amounts or smaller units. While it can be
  /// used to display the amount of ether in a human-readable format, it should
  /// not be used for anything else.
  Future<double> getTokenBalance({
    required String tokenAddress,
    required String walletAddress,
  });

  /// Returns the amount typically needed to pay for one unit of gas(in gwei).
  Future<double> getGasPrice();
}
