@JS()
library magic_ethereum;

import 'dart:html';

import 'package:js/js.dart';
import 'package:web3_browser/src/javascript.dart';
import 'package:web3_browser/web3_browser.dart';
import 'package:web3dart/json_rpc.dart' show RpcService;

@JS('ethereum')
external Ethereum? get _ethereum;

/// Extension to load the 'magicethereum' window property injected by Magic.js
extension GetMagicEthereum on Window {  //This stuff is good
  Ethereum? get magicEthereum => _ethereum;
}
