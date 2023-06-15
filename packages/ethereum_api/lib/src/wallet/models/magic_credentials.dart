import 'dart:js_util';
import 'dart:typed_data';

import 'package:ethereum_api/wallet_api.dart';
import 'package:web3dart/src/crypto/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

/// {An interface between web3dart and the Magic wallet for sending and signing transactions}
class MagicCredentials extends CredentialsWithKnownAddress
    implements CustomTransactionSender {
  @override
  final EthereumAddress _address;
  final MagicSDK _magicSDK;

  /// {The constructor class for MagicCredentials}
  MagicCredentials(MagicSDK magicSDK, String hexAddress)
      : _address = EthereumAddress.fromHex(hexAddress),
        _magicSDK = magicSDK;

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final txnString =
        await promiseToFuture<String>(_magicSDK.sendTransaction());
    return txnString;
  }

  @override
  MsgSignature signToEcSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    throw UnimplementedError('Magic Wallet does not support EIP1559');
  }

  @override
  Future<MsgSignature> signToSignature(
    Uint8List payload, {
    int? chainId,
    bool isEIP1559 = false,
  }) {
    throw UnsupportedError('Magic Wallet does not support signatures');
  }

  @override
  // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();
}
