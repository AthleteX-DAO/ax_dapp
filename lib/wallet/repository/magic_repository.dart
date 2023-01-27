import 'package:ax_dapp/wallet/javascript_calls/magic.dart';
import 'package:ax_dapp/wallet/javascript_calls/web3_rpc.dart';

class MagicRepository {
  MagicRepository({required MagicSDK magic}) : _magic = magic;
  final MagicSDK _magic;

  Future<dynamic> connect() async {
    // await _web3rpc.getAccounts(_magic.rpcProvider);
    await _magic.showWallet();
  }

  Future<void> showWallet() async {
    await _magic.showWallet();
  }

  Future<void> disconnect() async {
    await _magic.disconnect();
  }

  Future<dynamic> getWalletInfo() async {
    final walletInfo = await _magic.getWalletInfo();
    return walletInfo;
  }

  Future<dynamic> requestUserInfo() async {
    final email = await _magic.requestUserInfo();
    return email;
  }

  Future<dynamic> getIdToken() async {
    final idToken = await _magic.getIdToken();
    return idToken;
  }

  //TODO(anyone): return a class(?) that has the issuer, email, phoneNumber, publicAddress
  Future<dynamic> getMetadata() async {
    await _magic.getMetadata();
  }

  Future<dynamic> isLoggedIn() async {
    final isLoggedIn = await _magic.isLoggedIn();
    return isLoggedIn;
  }

  Future<void> logOut() async {
    await _magic.logOut();
  }
}
