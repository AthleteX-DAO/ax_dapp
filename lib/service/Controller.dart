
import 'package:web3dart/web3dart.dart';
import 'dart:html';

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  // Placeholder for ethers library (window.ethereum)
  static const ACTIVE_CHAIN_ID = 80001;
  var eth;
  Web3Client? _client;
  Credentials? _credentials;
  bool ethIsEnabled = false;
  bool activeChain = false;

  // final Contract staking = Contract(
  //     "0x063086C5b352F986718Db9383c894Be9Cd4350fA", abi, provider!.getSigner());
  // final ContractERC20 _axToken =
  //     ContractERC20("0x585E0c93F73C520ca6513fc03f450dAea3D4b493", ethereum!);
  Controller() {
    // TODO - init controller variables
  }

  // Getters
  Web3Client? get client => _client;
  Credentials? get credentials => _credentials;

  void updateClient(Web3Client _newClient) {
    _client = _newClient;
  }

  bool checkCorrectChain() {

    // ignore: unrelated_type_equality_checks
    _client!.getNetworkId() == ACTIVE_CHAIN_ID ? activeChain = true : activeChain = false;

    return activeChain;
  }
}
