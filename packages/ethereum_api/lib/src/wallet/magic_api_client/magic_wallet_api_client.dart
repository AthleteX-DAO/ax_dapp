import 'package:ethereum_api/wallet_api.dart';

/// {@template magic_wallet_api_client}
/// Client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
///
abstract class MagicApiClient with WalletApiClient {
  /// {@macro magic_api_client}

  /// Returns the current [EthereumChain] synchronously.
  @override
  EthereumChain get currentChain;

  /// Asks the user to connect with Magic
  Future<dynamic> connect();

  /// Returns information about a user's wallet.
  Future<void> getWalletInfo();

  /// Shows a wallet view for an authenticated user.
  Future<void> showWallet();

  /// Asks the user to share information with the requesting dApp
  /// Returns the user's email address if they consent.
  Future<void> requestUserInfo();

  /// Disconnects a user from their Magic wallet
  Future<void> disconnect();

  /// Asks the user to select an account and give your application access to it.
  /// Returns the [WalletCredentials] for the connected account.

  @override
  Future<WalletCredentials> getWalletCredentials();

  /// Connects to the magic client
  Future<dynamic> requestAccount();
}