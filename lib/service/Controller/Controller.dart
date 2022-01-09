// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, invalid_use_of_internal_member

import 'dart:html';

import 'dart:math';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:web3dart/browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Controller extends GetxController {
  var client = Web3Client("url", Client()).obs;
  var credentials;
  var publicAddress =
      EthereumAddress.fromHex("0xcdaa8c55fB92fbBE61948aDf4Ba8Cf7Ad33DBeF0").obs;
  var networkID = 0.obs;
  bool walletConnected = false;

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic = "";
  var privateAddress = "";
  static String latestTx = "";
  var gas = EtherAmount.zero().obs;
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

  // Connect the dapp to metamask and update relevant values
  void connect() async {
    final eth = window.ethereum;
    walletConnected = true;
    client.value = Web3Client.custom(eth!.asRpcService());
    credentials = await eth.requestAccount();
    print("[Console] connecting to the decentralized web!");
    networkID.value = await client.value.getNetworkId();
    publicAddress.value = await credentials.extractAddress();
    gas.value = await client.value.getGasPrice();
    print("[Console] updated client: $client and credentials: $credentials");
    update();
  }

  void getCurrentGas() async {
    final eth = window.ethereum;
    gas.value = await Web3Client.custom(eth!.asRpcService())
        .getBalance(publicAddress.value);
  }

  void updateTxString(String tx) {
    print("latest txString: $tx");
    latestTx = tx;
  }

  void disconnect() async {
    final eth = window.ethereum;
    walletConnected = eth!.isConnected();
    client.value.dispose();
    client.value.getChainId();

    update();
  }

  static void switchNetwork() async {
    final eth = window.ethereum;
    Object params = [
      {'chainID': '0xf00'}
    ];
    eth!.rawRequest('wallet_switchEthereumChain', params: {params});
  }

  static void viewTx() async {
    String urlString = "";
    latestTx == ""
        ? urlString = "https://mumbai.polygonscan.com"
        : urlString = 'https://mumbai.polygonscan.com/tx/$latestTx';
    await launch(urlString);
  }
}
