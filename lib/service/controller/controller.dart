// ignore_for_file: only_throw_errors

import 'dart:developer';

import 'package:ax_dapp/service/controller/create_wallet/abstract_wallet.dart';
import 'package:ax_dapp/service/controller/create_wallet/create_wallet.dart'
    if (dart.library.io) './create_wallet/mobile.dart'
    if (dart.library.js) './create_wallet/web.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

//Comment this for Android
const kEmptyWalletId = '0x0000000000000000000000000000000000000000';

class Controller extends GetxController {
  Controller() {
    initState();
  }

  /// VARIABLES
  String seedHex = '';
  late Credentials credentials;
  String mnemonic = '';
  RxInt networkID = 0.obs;
  bool activeChain = false;
  static String latestTx = '';
  bool walletConnected = false;
  Rx<EtherAmount> gas = EtherAmount.zero().obs;
  RxString gasString = '0'.obs;
  static const mainnetChainId = 137;
  static const testnetChainId = 80001;
  static const mainnetSXChainId = 416;
  int activeChainId = testnetChainId;
  static const supportedChains = {
    137: 'https://polygon-rpc.com',
    80001: 'https://matic-mumbai.chainstacklabs.com'
  };
  String mainRPCUrl = 'https://polygon-rpc.com';
  String testRPCUrl = 'https://matic-mumbai.chainstacklabs.com/';
  Rx<Web3Client> client = Web3Client('https://polygon-rpc.com', Client()).obs;
  Rx<EthereumAddress> publicAddress =
      EthereumAddress.fromHex(kEmptyWalletId).obs;

  // ignore: avoid_setters_without_getters
  set axTokenAddress(EthereumAddress tokenAddress) {
    axTokenAddress = EthereumAddress.fromHex(tokenAddress.hex);
  }

  Future<void> initState() async {
    //getCurrentGas();
  }

  Future<int> connect() async {
    //Setting up Client & Credentials for connecting to dApp from a client
    final web3 = newWallet();
    try {
      //Connect and setup credentials
      await web3.connect();
      final publicAddress = web3.publicAddress as EthereumAddress?;
      log('Connected wallet: $publicAddress');
      if (publicAddress == null) {
        throw const MetaMaskUnavailableFailure();
      }
      this.publicAddress.value = publicAddress;
    } catch (_) {
      return -1;
    }

    try {
      networkID.value = web3.networkID as int;
      log('Connected network: ${networkID.value}');
    } catch (e) {
      throw 'NetworkId value is breaking $e';
    }

    try {
      client.value = web3.client as Web3Client;
    } catch (e) {
      throw 'Client value is breaking: $e';
    }

    try {
      credentials = web3.credentials as Credentials;
    } catch (e) {
      throw 'credentials are breaking $e';
    }

    if (web3.networkID != null) {
      walletConnected = true;
    }

    return 1;
  }
  //Comment this for Android
  // Connect the dapp to metamask and update relevant values

  // Connect the client + set credentials

  Future<void> getCurrentGas() async {
    final rawGasPrice = await client.value.getGasPrice();
    final gasPriceinGwei =
        rawGasPrice.getValueInUnit(EtherUnit.gwei).toStringAsFixed(2);

    gasString.value = gasPriceinGwei;
    log('Latest gas: $gasString');
    update();
  }

  // ignore: use_setters_to_change_properties
  void updateTxString(String tx) {
    latestTx = tx;
  }

  void changeAddress() {
    throw UnsupportedError('MetaMask is the only currently supported wallet!');
  }

  Future<void> disconnect() async {
    walletConnected = false;
    await client.value.dispose();

    // client.value.getChainId();
    update();
  }

  static Future<void> viewTx() async {
    var urlString = Uri.parse('');
    latestTx == ''
        ? urlString = Uri.parse('https://polygonscan.com')
        : urlString = Uri.parse('https://polygonscan.com/tx/$latestTx');
    await launchUrl(urlString);
  }
}
