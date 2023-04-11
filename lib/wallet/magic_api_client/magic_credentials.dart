import 'dart:typed_data';

import 'package:shared/shared.dart';
import 'package:web3_browser/web3_browser.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

class MagicCredentials extends Equatable {
  const MagicCredentials(CredentialsWithKnownAddress credentials)
      : _credentials = credentials;

  final CredentialsWithKnownAddress _credentials;
  @override
  // TODO: implement props
  List<Object?> get props => [_credentials.address];
}

extension MagicCredentialsX on MagicCredentials {
    /// {@macro _credentials}
  CredentialsWithKnownAddress get value => _credentials;

  /// Returns the wallet address obtained from [CredentialsWithKnownAddress].
  String get walletAddress => value.address.hex.toLowerCase();
}


/// Support for using web3dart with browser clients such as MetaMask.
///
/// ## Example
///
/// ```dart
/// import 'dart:convert';
/// import 'dart:html';
/// import 'dart:typed_data';
///
/// import 'package:web3dart/browser.dart';
/// import 'package:web3dart/web3dart.dart';
///
/// Future<void> main() async {
///   final eth = window.ethereum;
///   if (eth == null) {
///     print('MetaMask is not available');
///     return;
///   }
///
///   final client = Web3Client.custom(eth.asRpcService());
///   final credentials = await eth.requestAccount();
///
///   print('Using ${credentials.address}');
///   print('Client is listening: ${await client.isListeningForNetwork()}');
///
///   final message = Uint8List.fromList(utf8.encode('Hello from web3dart'));
///   final signature = await credentials.signPersonalMessage(message);
///   print('Signature: ${base64.encode(signature)}');
/// }
/// ```
/// 
/// 
