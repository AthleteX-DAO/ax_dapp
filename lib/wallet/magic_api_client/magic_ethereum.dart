@JS()
library magic_ethereum;

import 'dart:html';

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:web3_browser/src/javascript.dart';
import 'package:web3_browser/web3_browser.dart';
import 'package:web3dart/json_rpc.dart';

@JS('ethereum')
external MagicEthereum? get _ethereum;

/// Extension to load obtain the `ethereum` window property injected by
/// Ethereum browser plugins.
extension GetMagicEthereum on Window {
  /// Loads the ethereum instance provided by the browser.
  ///
  /// For more information on how to use this object with the web3dart package,
  /// see the methods on [DartEthereum].

  MagicEthereum? get magicEthereum => _ethereum;
}

class MagicEthereum with Ethereum {
  // /// This should not be used in user code. Use `stream(event)` instead.
  // @override
  // external void on(String event, Function callback);

  // /// This should not be used in user code. Use `stream(event)` instead.
  // @override
  // external void removeListener(String event, Function callback);

  /// Turns this raw client into an rpc client that can be used to create a
  /// `Web3Client`:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   final eth = window.ethereum;
  ///   if (eth == null) {
  ///     print('MetaMask is not available');
  ///     return;
  ///   }
  ///
  ///   final client = Web3Client.custom(eth.asRpcService());
  /// }
  /// ```
  RpcService asRpcService() => _MagicRpcService(this);

  /// Sends a raw rpc request using the injected Ethereum client.
  ///
  /// If possible, prefer using [asRpcService] to construct a high-level client
  /// instead.
  ///
  /// See also:
  ///  - the rpc documentation under https://docs.metamask.io/guide/rpc-api.html
}

class _MagicRpcService extends RpcService {
  _MagicRpcService(this._ethereum);

  final Ethereum _ethereum;

  @override
  Future<RPCResponse> call(String function, [List? params]) async {
    final res = await _ethereum.rawRequest(function, params: params);

    return RPCResponse(0, res);
  }
}
