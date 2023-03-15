@JS()
library magic_sdk;

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
}
