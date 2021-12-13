import 'dart:math';
import 'package:web3dart/credentials.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic;
  var privateAddress;
  var credentials;
  var publicAddress;

  factory Singleton([String? mnemonic]) {
    return _instance;
  }

  Future<String> createNewMnemonic() async {
    mnemonic = bip39.generateMnemonic();
    return retrieveWallet(mnemonic);
  }

  Future<String> retrieveWallet([String? _mnemonic]) async {
    mnemonic = _mnemonic;
    privateAddress = bip39.mnemonicToSeedHex(mnemonic);
    credentials = EthPrivateKey.fromHex(privateAddress);
    publicAddress = await credentials.extractAddress();
    return mnemonic;
  }
}