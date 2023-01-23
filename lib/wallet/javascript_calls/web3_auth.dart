@JS()
library web3auth;

import 'package:js/js.dart';

@JS()
class Web3Auth {
  external Web3Auth(
    String clientId,
    String chainNameSpace,
    String chainId,
    String rpcTarget,
  );
  external Future<dynamic> initModal();
  external Future<dynamic> connect();
  external Future<dynamic> logout();
  external Future<dynamic> getUserInfo();
}
