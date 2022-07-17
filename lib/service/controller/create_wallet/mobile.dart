// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';

import 'package:ax_dapp/service/controller/create_wallet/abstract_wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
// Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

DappWallet newWallet() => MobileWallet();

class MobileWallet extends DappWallet {
  String rpcUrl = 'https://polygon-rpc.com';

  @override
  Future<void> connect() async {
    var rpcUrl = '';
    const mainRPCUrl = 'https://polygon-rpc.com';
    const testRPCUrl = 'https://matic-mumbai.chainstacklabs.com/';

    switch (activeChainId) {
      case 137:
        rpcUrl = mainRPCUrl;
        break;
      default:
        rpcUrl = testRPCUrl;
    }

    if (seedHex == null) {
      createNewMnemonic();
    }

    client = Web3Client(rpcUrl, Client());
    publicAddress = credentials.extractAddress();
    credentials = EthPrivateKey.fromHex(seedHex as String);
    networkID = client.getNetworkId();
    log('Updated client and credentials at: $publicAddress');
  }

  void createNewMnemonic() {
    mnemonic = bip39.generateMnemonic();
    seedHex = bip39.mnemonicToSeedHex(mnemonic as String);
  }

// This will import mnemonics & convert to seed hexes
  Future<bool> importMnemonic(String _mnemonic) async {
    // validate if mnemonic
    final isValidMnemonic = bip39.validateMnemonic(_mnemonic);
    if (isValidMnemonic) {
      seedHex = bip39.mnemonicToSeedHex(_mnemonic);
      mnemonic = _mnemonic;
    }
    return isValidMnemonic;
  }
}
