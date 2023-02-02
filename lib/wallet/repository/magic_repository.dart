import 'package:ax_dapp/wallet/magic_api_client/web.dart';

class MagicRepository {
  MagicRepository({required MagicApiClient magicWalletApiClient})
      : _magicWalletApiClient = magicWalletApiClient;
  final MagicApiClient _magicWalletApiClient;

  Future<dynamic> connect() async {
    await _magicWalletApiClient.connect();
  }

  Future<void> showWallet() async {
    await _magicWalletApiClient.showWallet();
  }

  Future<void> disconnect() async {
    await _magicWalletApiClient.disconnect();
  }

  Future<dynamic> getWalletInfo() async {
    final walletInfo = await _magicWalletApiClient.getWalletInfo();
    return walletInfo;
  }

  Future<dynamic> requestUserInfo() async {
    final email = await _magicWalletApiClient.requestUserInfo();
    return email;
  }
}
