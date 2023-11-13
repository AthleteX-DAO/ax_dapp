import 'package:ethereum_api/src/wallet/models/models.dart';

/// {@template wallet_api_client}
/// Client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}
abstract class WalletApiClient {
  /// {@macro wallet_api_client}

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get chainChanges;

  /// returns the Wallets private seed phrase
  String get hex;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get currentChain;

  /// Adds the specified [chain] to user's wallet.
  Future<void> addChain(EthereumChain chain);

  /// Switches the currently used chain.
  Future<void> switchChain(EthereumChain chain);

  /// Sync the current used chain
  Future<void> syncChain(EthereumChain chain);

  /// Updates the currently used chain
  Future<void> updateChain(EthereumChain chain);

  /// Returns current Token decimals
  Future<BigInt> getDecimals(String tokenAddress);

  /// Creates new wallet credentials for users signing onto athletex dapp
  /// Returns the [WalletCredentials] for the newly created account.
  Future<WalletCredentials> createWalletCredentials();

  /// Creates wallet credentials for a user based on a private key
  /// Returns the [WalletCredentials] for the improted account
  Future<WalletCredentials> importWalletCredentials(String hex);

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
