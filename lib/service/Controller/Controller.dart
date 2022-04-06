// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, invalid_use_of_internal_member

import './createWallet/createWallet.dart'
    if (dart.library.io) './createWallet/mobile.dart'
    if (dart.library.js) './createWallet/web.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';
//Comment this for Android

class Controller extends GetxController {
  /// VARIABLES
  var seedHex = "";
  var credentials;
  var mnemonic = "";
  var networkID = 0.obs;
  bool activeChain = false;
  static String latestTx = "";
  bool walletConnected = false;
  var gas = EtherAmount.zero().obs;
  var gasString = "0".obs;
  static const MAINNET_CHAIN_ID = 137;
  static const TESTNET_CHAIN_ID = 80001;
  int activeChainId = TESTNET_CHAIN_ID;
  static const supportedChains = {
    137: "https://polygon-rpc.com",
    80001: "https://matic-mumbai.chainstacklabs.com"
  };
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";
  var client = Web3Client("url", Client()).obs;
  var publicAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000").obs;

  set axTokenAddress(EthereumAddress tokenAddress) {
    axTokenAddress = EthereumAddress.fromHex("${tokenAddress.hex}");
  }

  Controller() {
    initState();
  }

  void initState() async {
    //getCurrentGas();
  }

  Future<int> connect() async {
    //Setting up Client & Credentials for connecting to dApp from a client
    var web3 = newWallet();

    //Connect and setup credentials
    await web3.connect();
    
    publicAddress.value = web3.publicAddress;
    credentials.value = web3.credentials;
    networkID.value = web3.networkID;
    client.value = web3.client;
    return 1;
  }
  //Comment this for Android
  // Connect the dapp to metamask and update relevant values

  // Connect the client + set credentials

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

  void changeAddress() async {}

  void disconnect() async {
    walletConnected = false;
    client.value.dispose();

    // client.value.getChainId();
    update();
  }

  static void viewTx() async {
    String urlString = "";
    latestTx == ""
        ? urlString = "https://mumbai.polygonscan.com"
        : urlString = 'https://mumbai.polygonscan.com/tx/$latestTx';
    await launch(urlString);
  }
}
