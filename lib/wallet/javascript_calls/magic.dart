@JS()
library MagicSDKsdk;

import 'package:js/js.dart';

@JS()
class MagicSDK {
  external MagicSDK(
    String apiKey,
    int chainId,
    String rpcUrl,
    String locale,
  );

  external dynamic get rpcProvider;
  external Future<dynamic> connect();
  external Future<dynamic> showWallet();
  external Future<dynamic> disconnect();
  external Future<dynamic> getWalletInfo();
  external Future<dynamic> requestUserInfo();
  external Future<dynamic> getIdToken();
  external Future<dynamic> getMetadata();
  external Future<dynamic> isLoggedIn();
  external Future<dynamic> logOut();
}
