@JS()
library magic;

import 'package:js/js.dart';

@JS()

class Magic {
  external Magic(
    String apiKey,
    int chainId,
    String rpcUrl,
    String locale,
  );

  external Future<dynamic> showWallet();
  external Future<dynamic> disconnect();
  external Future<dynamic> getWalletInfo();
  external Future<dynamic> requestUserInfo();
  external Future<dynamic> getIdToken();
  external Future<dynamic> getMetadata();
  external Future<dynamic> isLoggedIn();
  external Future<dynamic> logOut();
}
