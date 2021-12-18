import 'dart:html';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Controller {
  Controller._privateConstructor();

  static final Controller _instance = Controller._privateConstructor();

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic;
  var privateAddress;
  var credentials;
  var client;
  var publicAddress;
  static const MAINNET_CHAIN_ID = 137;
  var AXAddress = EthereumAddress.fromHex("0x76d9a6e4cdefc840a47069b71824ad8ff4819e85");
  String rpcUrl = "https://polygon-rpc.com";
  bool activeChain = false;

  set axTokenAddress(String tokenAddress) {
    AXAddress = EthereumAddress.fromHex("$tokenAddress");
  }

  factory Controller([String? mnemonic]) {
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

  // Web functionality
  void connect() async {
    final eth = window.ethereum;
    final client = Web3Client.custom(eth!.asRpcService());
    final credentials = await eth.requestAccount();
    print("[Console] connecting to the decentralized web!");
    update(client, credentials);
  }

  void update(var cl, var cr) async {
    client = cl;
    publicAddress = await cr.extractAddress();
    print("[Console] updated client: ${cl} and credentials: ${cr}");
  }

  void viewTx(String txAddress) async {
    String urlString = 'https://polygonscan.com/tx/$txAddress';
    await launch(urlString);
  }
}
