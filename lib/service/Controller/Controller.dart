// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, invalid_use_of_internal_member

import 'dart:html';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';
import 'package:web3dart/browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Controller extends GetxController {
  var client =
      Web3Client("https://matic-mumbai.chainstacklabs.com/", Client()).obs;
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
  var gasString = "0".obs;
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
  Future<void> connect() async {
    final eth = window.ethereum;
    if (eth == null) {
      print('[Console] MetaMask is not available');
      return;
    }
    walletConnected = true;
    client.value = Web3Client.custom(eth.asRpcService());
    credentials = await eth.requestAccount();
    print('[Console] Connecting the wallet...');
    networkID.value = await client.value.getNetworkId();
    if (networkID.value != MAINNET_CHAIN_ID &&
        networkID.value != TESTNET_CHAIN_ID) {
      print(
          "[Console] Wrong network ID: $networkID. Connect to mainnet(137) or testnet (80001) and try again");
      return;
    }
    print("[Console] Initial adress: $publicAddress.value");
    publicAddress.value = await credentials.extractAddress();
    print("[Console] Updated adress: $publicAddress.value");
    var rawGasPrice = await client.value.getGasPrice();
    var gasPriceinGwei = rawGasPrice.getValueInUnit(EtherUnit.gwei);
    gasString.value = "$gasPriceinGwei";
    print("[Console] Updated client and credentials");
    update();
  }

  void getCurrentGas() async {
    var rawGasPrice = await client.value.getGasPrice();
    var gasPriceinGwei = rawGasPrice.getValueInUnit(EtherUnit.gwei);
    gasString.value = "$gasPriceinGwei";
    print('Getting latest gas... $gasString');
    update();
  }

  void updateTxString(String tx) {
    print("latest txString: $tx");
    latestTx = tx;
  }

  void changeAddress() async {
    final eth = window.ethereum;
    eth!.requestAccount();
  }

  void disconnect() async {
    walletConnected = false;
    client.value.dispose();
    //client.value.getChainId();
    update();
  }

  void addTokenToWallet() async {
    final eth = window.ethereum;
    Object tokenParam = {
      "type": "ERC20",
      "options": {
        "address": "0xb60e8dd61c5d32be8058bb8...",
        "symbol": "FOO",
        "decimals": 18,
        "image": "https: //foo.io/token-ima..."
      }
    };

    eth!.rawRequest('wallet_watchAsset', params: tokenParam);
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
