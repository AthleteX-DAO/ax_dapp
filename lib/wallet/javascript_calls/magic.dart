@JS()
library magic;

import 'package:ax_dapp/wallet/javascript_calls/connect_extension.dart';
import 'package:js/js.dart';

@JS()
class Magic {
  external Magic(
    String apiKey,
    int chainId,
    String rpcUrl,
    String locale, 
  );

  external dynamic get rpcProvider;
  external Future<dynamic> showWallet();
  external Future<dynamic> disconnect();
  external Future<dynamic> getWalletInfo();
  external Future<dynamic> requestUserInfo();
  external Future<dynamic> getIdToken();
  external Future<dynamic> getMetadata();
  external Future<dynamic> isLoggedIn();
  external Future<dynamic> logOut();
}
