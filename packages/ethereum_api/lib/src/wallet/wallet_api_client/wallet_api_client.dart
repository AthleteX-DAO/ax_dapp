import 'package:ethereum_api/src/wallet/models/models.dart';

/// {@template wallet_api_client}
/// Client that manages the wallet API(i.e. MetaMask).
/// {@endtemplate}
abstract class WalletApiClient {
  /// {@macro wallet_api_client}

  /// Allows listening to changes to the current [EthereumChain].
  Stream<EthereumChain> get ethereumChainChanges;

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get ethereumChain;

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
}
