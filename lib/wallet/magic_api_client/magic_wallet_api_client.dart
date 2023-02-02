/// {@template wallet_api_client}
/// Client that manages the wallet API(i.e. Magic).
/// {@endtemplate}
///
abstract class MagicWalletApiClient {
  /// {@macro magic_api_client}

  /// Asks the user to connect with Ethers library
  Future<void> connect();

  /// Returns information about a user's wallet such as the [walletType].
  Future<void> getWalletInfo();

  /// Shows a wallet view for an authenticated user.
  Future<void> showWallet();

  /// Asks the user to share information with the requesting dApp
  /// Returns the user's email address if they consent.
  Future<void> requestUserInfo();

  /// Disconnects a user from their magic wallet
  Future<void> disconnect();
}
