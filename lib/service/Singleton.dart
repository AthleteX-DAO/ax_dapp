import 'dart:math';
import 'package:web3dart/credentials.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Singleton {
  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  factory Singleton() {
    return _instance;
  }

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic;
  var privateAddress;
  var credentials;
  var publicAddress;

  Future<void> createNewMnemonic() async {
    mnemonic = bip39.generateMnemonic();
    privateAddress = bip39.mnemonicToSeedHex(mnemonic);
    credentials = EthPrivateKey.fromHex(privateAddress);
    publicAddress = await credentials.extractAddress();
  }

  Future<void> retrieveWallet([String? _mnemonic]) async {
    mnemonic = _mnemonic;
    privateAddress = bip39.mnemonicToSeedHex(mnemonic);
    credentials = EthPrivateKey.fromHex(privateAddress);
    publicAddress = await credentials.extractAddress();
  }

  


}