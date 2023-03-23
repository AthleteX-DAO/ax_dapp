import 'package:ax_dapp/wallet/magic_api_client/web.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/wallet_repository.dart';

class MagicRepository {
  MagicRepository({required MagicApiClient magicWalletApiClient})
      : _magicWalletApiClient = magicWalletApiClient;
  final MagicApiClient _magicWalletApiClient;

  final _magicWalletChangeController = BehaviorSubject<Wallet>();

  /// Returns the current [EthereumChain] synchronously.
  EthereumChain get currentChain => _magicWalletApiClient.currentChain;

  ValueStream<Wallet> get _walletChanges => _magicWalletChangeController.stream;

  /// Allows listening to changes to the current [Wallet].
  Stream<Wallet> get walletChanges => _walletChanges;

  /// Allows the user to connect to a 'Magic' wallet.
  ///
  /// Returns the hexadecimal representation of the wallet address.
  ///
  /// Throws:
  Future<dynamic> connect() async {
    try {
      final walletAddress = await _magicWalletApiClient.connect();
      _magicWalletChangeController.add(
        Wallet(
          status: WalletStatus.fromChain(EthereumChain.polygonMainnet),
          address: walletAddress.toString(),
          chain: currentChain,
        ),
      );
      return walletAddress;
    } catch (_) {}
  }

  /// Allows the user to show their 'Magic' wallet.
  ///
  /// Throws:
  Future<void> showWallet() async {
    await _magicWalletApiClient.showWallet();
  }

  /// Disconnects the user from their 'Magic' wallet.
  ///
  /// Throws:
  Future<void> disconnect() async {
    _magicWalletChangeController.add(
        Wallet(
          status: WalletStatus.fromChain(EthereumChain.none),
          address: kEmptyAddress,
          chain: EthereumChain.none,
        ),
      );
    await _magicWalletApiClient.disconnect();
  }

  /// Allows the user to retrieve information about their wallet.
  ///
  /// Throws:
  Future<dynamic> getWalletInfo() async {
    final walletInfo = await _magicWalletApiClient.getWalletInfo();
    return walletInfo;
  }

  /// Allows the user to send their information upon request
  ///
  /// Returns a string representation of the email address
  /// that is associated with the 'Magic' wallet
  ///
  /// Throws:
  Future<dynamic> requestUserInfo() async {
    final email = await _magicWalletApiClient.requestUserInfo();
    return email;
  }
}
