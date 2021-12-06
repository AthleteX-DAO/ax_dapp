import 'dart:html';
import 'dart:math';

import 'package:ae_dapp/pages/HomePage.dart';
import 'package:http/http.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/src/browser/dart_wrappers.dart';
import 'package:web3dart/src/browser/javascript.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ae_dapp/contracts/StakingRewards.g.dart';
import 'package:ae_dapp/contracts/AthleteX.g.dart';

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  // Placeholder for ethers library (window.ethereum)
  static const ACTIVE_CHAIN_ID = 80001;
  var eth;
  late Web3Client _client;
  late Credentials _credentials;
  late AthleteX _athleteX = AthleteX(address: axTokenAddr, client: client);
  late Erc20 _erc20;
  bool ethIsEnabled = false;
  bool activeChain = false;

  Controller() {
    // TODO - init controller variables
    init();
  }

  void init() async {
    _client = Web3Client(_rpcUrl, new Client());
    if (window.ethereum != null) {
      updateClient(_client);
      updateCredentials(await window.ethereum!.requestAccount());
    }
  }

  // Getters
  Web3Client get client => _client;
  Credentials get credentials => _credentials;
  String get rpc => _rpcUrl;
  String get ws => _wsUrl;
  AthleteX get athleteX => _athleteX;
  Erc20 get genericERC20 => _erc20;

  void updateClient(Web3Client _newClient) {
    _client = _newClient;
  }

  void updateCredentials(Credentials _newCredentials) async {
    _credentials = _newCredentials;
  }

  bool checkCorrectChain() {
    // ignore: unrelated_type_equality_checks
    _client.getNetworkId() == ACTIVE_CHAIN_ID
        ? activeChain = true
        : activeChain = false;

    return activeChain;
  }
}
