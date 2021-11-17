import 'package:flutter_web3/ethereum.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/browser.dart';
import 'dart:html';

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  // Placeholder for ethers library (window.ethereum)
  static const ACTIVE_CHAIN_ID = 80001;
  var eth;
  late Web3Client _client;
  late Credentials _credentials;
  bool ethIsEnabled = false;
  bool activeChain = false;

  // final Contract staking = Contract(
  //     "0x063086C5b352F986718Db9383c894Be9Cd4350fA", abi, provider!.getSigner());
  // final ContractERC20 _axToken =
  //     ContractERC20("0x585E0c93F73C520ca6513fc03f450dAea3D4b493", ethereum!);
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
