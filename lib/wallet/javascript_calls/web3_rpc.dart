@JS()
library web3rpc;

import 'package:js/js.dart';

@JS()
class Web3RPC {
  external Future<dynamic> getChainId(dynamic provider);
  external Future<dynamic> getAccounts(dynamic provider);
  external Future<dynamic> getBalance(dynamic provider);
  external Future<dynamic> sendTransaction(dynamic provider);
  external Future<dynamic> signMessage(dynamic provider);
  external Future<dynamic> getPrivateKey(dynamic provider);
}
