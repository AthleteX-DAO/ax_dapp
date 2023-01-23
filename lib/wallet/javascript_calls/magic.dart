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
}
