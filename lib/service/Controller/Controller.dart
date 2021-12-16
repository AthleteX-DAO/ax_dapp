// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:ae_dapp/contracts/AthleteX.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/browser.dart';
import 'package:http/http.dart';

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';

  static const ACTIVE_CHAIN_ID = 80001;
  var eth;
  late Web3Client _client;
  late Credentials _credentials;
  // Defined Staking
  EthereumAddress stakingAddr =
      EthereumAddress.fromHex("0x9CCf92AF15B81ba843a7dF58693E7125196F30aB");
// Defined AthelteX
  final EthereumAddress axTokenAddr =
      EthereumAddress.fromHex("0xaa2b20858EFdaD6eE33Aef91007C73979a87492e");
  late AthleteX _athleteX = AthleteX(address: axTokenAddr, client: client);
  late Erc20 _erc20;
  late EthereumAddress _publicAddress =
      EthereumAddress.fromHex("0x8c086885624c5b823cc6fca7bff54c454d6b5239");
  bool ethIsEnabled = false;
  bool activeChain = false;

  Controller() 
  {
    if (window.ethereum != null)
    {
      
    }
  }

  void connect() async {
    final eth = window.ethereum;
    final client = Web3Client.custom(eth!.asRpcService());
    final credentials = await eth.requestAccount();
    print("[Console] connecting to the decentralized web!");
    update(client, credentials);
  }

  void update(var cl, var cr) async {
    client = cl;
    credentials = cr;
    print("[Console] updated client: ${cl} and credentials: ${cr}");
  }

  // Getters
  Web3Client get client => _client;
  Credentials get credentials => _credentials;
  String get rpc => _rpcUrl;
  String get ws => _wsUrl;
  AthleteX get athleteX => _athleteX;
  Erc20 get genericERC20 => _erc20;
  EthereumAddress get axTokenAddress => axTokenAddr;
  EthereumAddress get publicAddress => _publicAddress;

  // Setters
  set publicAddress(EthereumAddress pA) {
    _publicAddress = pA;
  }

  set credentials(Credentials creds) {
    _credentials = creds;
  }

  set client(Web3Client cl) {
    _client = cl;
  }

  bool checkCorrectChain() {
    // ignore: unrelated_type_equality_checks
    _client.getNetworkId() == ACTIVE_CHAIN_ID
        ? activeChain = true
        : activeChain = false;

    return activeChain;
  }

  void switchChain(int chainID) {
    switch (chainID) {
      case 80001:
        break;

      case 137:
        break;

      default:
    }
  }

  void viewTx(String txAddress) async {
    String urlString = 'https://polygonscan.com/tx/$txAddress';
    await launch(urlString);
  }
}
