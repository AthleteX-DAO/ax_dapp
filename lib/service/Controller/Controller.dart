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
    await newWallet().connect();
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

  //Comment this for Android
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

  Future<bool> switchNetwork() async {
    print("Inside switchNetwork()");
    final eth = window.ethereum;
    Object switchParams = [
      {'chainId': '0x89'}
    ];
    try {
      print("[Console] Trying to switch the network");
      await eth!.rawRequest('wallet_switchEthereumChain', params: switchParams);
      print("[Console] Switched the network to mainnet(137, 0x89?)");
      return true;
    } catch (error) {
      print("[Console] Main network not installed on MetaMask");
      try {
        Object addParams = [
          {
            'chainId': '0x89',
            'chainName': 'Matic(Mainnet)',
            'rpcUrls': mainRPCUrl,
          }
        ];
        await eth!.rawRequest('wallet_addEthereumChain', params: addParams);
        print("[Console] Added a mainnet to the MetaMask");
        return true;
      } catch (addError) {
        print("[Console] Could not add a mainnet to the MetaMask");
        return false;
      }
    }
  }

  static void viewTx() async {
    String urlString = "";
    latestTx == ""
        ? urlString = "https://mumbai.polygonscan.com"
        : urlString = 'https://mumbai.polygonscan.com/tx/$latestTx';
    await launch(urlString);
  }
}
