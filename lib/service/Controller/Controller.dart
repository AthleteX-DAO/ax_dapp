// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, invalid_use_of_internal_member

import 'dart:html';

import 'dart:math';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:web3dart/src/browser/javascript.dart';
import 'package:web3dart/browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Controller extends GetxController {
  Web3Client client = Web3Client("url", Client());
  Credentials credentials = EthPrivateKey.createRandom(new Random());
  EthereumAddress publicAddress =
      EthereumAddress.fromHex("0xcdaa8c55fB92fbBE61948aDf4Ba8Cf7Ad33DBeF0");
  int networkID = 0;
  bool walletConnected = false;
  Controller._privateConstructor();

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic = "";
  var privateAddress = "";
  String latestTx = "";
  var gas = EtherAmount.zero();
  bool activeChain = false;
  static const MAINNET_CHAIN_ID = 137;
  static const TESTNET_CHAIN_ID = 80001;
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

  set axTokenAddress(EthereumAddress tokenAddress) {
    axTokenAddress = EthereumAddress.fromHex("${tokenAddress.hex}");
  }

  Controller() {
    initState();
  }

  void initState() async {
    getCurrentGas();
  }

  void createNewMnemonic() {
    mnemonic = bip39.generateMnemonic();
    update();
  }

  Future<String> retrieveWallet([String? _mnemonic]) async {
    mnemonic = _mnemonic!;
    privateAddress = bip39.mnemonicToSeedHex(mnemonic);
    credentials = EthPrivateKey.fromHex(privateAddress);
    update();
    return mnemonic;
  }

  // Web functionality
  void connect() async {
    final eth = window.ethereum;
    walletConnected = true;
    client = Web3Client.custom(eth!.asRpcService());
    credentials = await eth.requestAccount();
    print("[Console] connecting to the decentralized web!");
    networkID = await client.getNetworkId();
    publicAddress = await credentials.extractAddress();
    gas = await client.getGasPrice();
    print("[Console] updated client: $client and credentials: $credentials");
    update();
  }

  void getCurrentGas() async {
    final eth = window.ethereum;
    gas =
        await Web3Client.custom(eth!.asRpcService()).getBalance(publicAddress);
  }

  void updateTxString(String tx) {
    latestTx = tx;
  }

  void disconnect() async {
    final eth = window.ethereum;
    walletConnected = eth!.isConnected();
    client.dispose();

    update();
  }

  static void switchNetwork() async {
    final eth = window.ethereum;
    Object params = [
      {'chainID': '0xf00'}
    ];
    eth!.rawRequest('wallet_switchEthereumChain', params: {params});
  }

  void viewTx() async {
    String urlString = 'https://polygonscan.com/tx/$latestTx';
    await launch(urlString);
  }
}
