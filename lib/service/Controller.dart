import 'package:flutter_web3/ethereum.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:web3dart/browser.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:html';

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  late JsonRpcProvider rpcProvider;
  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  var eth;
  var _client;
  var _credentials;

  // final Contract staking = Contract(
  //     "0x063086C5b352F986718Db9383c894Be9Cd4350fA", abi, provider!.getSigner());
  // final ContractERC20 _axToken =
  //     ContractERC20("0x585E0c93F73C520ca6513fc03f450dAea3D4b493", ethereum!);

  // No-args constructor
  Controller() {
    if (eth == null) {
      print('MetaMask is not available');
      return;
    }

    init();
  }

  init() async {
    eth = window.ethereum;
    _client = Web3Client.custom(eth!.asRpcService());
    _credentials = await eth.requestAccount();
  }

  // Getters
  Web3Client get client => _client;
  Credentials get credentials => _credentials;
}
