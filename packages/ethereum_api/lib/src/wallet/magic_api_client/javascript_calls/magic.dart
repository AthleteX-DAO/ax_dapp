@JS()
library magic_sdk;

import 'package:js/js.dart';

@JS()

/// {template} MagicSDK:
class MagicSDK {
  external MagicSDK(
    String apiKey,
  );

  external dynamic get rpcProvider;
  external Future<dynamic> connect();
  external Future<dynamic> showWallet();
  external Future<dynamic> sendTransaction();
  external Future<dynamic> disconnect();
  external Future<dynamic> getWalletInfo();
  external Future<dynamic> requestUserInfo();
  external Future<dynamic> getGasPrice();
  external Future<dynamic> getChainId();
  external Future<dynamic> getDecimals(String tokenAddress);
  external Future<dynamic> addToken(String tokenAddress, String tokenUrl);
  external Future<dynamic> requestAccount();
}
