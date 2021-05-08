import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

// State management
class ContractLinking extends ChangeNotifier {
  // RPC & WS are now linked to BSC-Testnet
  final String _rpcUrl = "https://data-seed-prebsc-1-s1.binance.org:8545/";
  final String _wsUrl = "wss://testnet-dex.binance.org/api/";

  // private client for web3dart
  Web3Client _client;
  bool isLoading = true;

  // Eth related variable declarations
  String _abiCode;
  EthereumAddress _contractAddress, publicAddress;
  Credentials _credentials;
  DeployedContract empCreator, registry, identifierWhitelist;

  // No-args constructor
  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    // Setup connection between eth rpc node & dApp
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    empCreator = await generateContract("ExpiringMultiParyCreator");
    registry = await generateContract("Registry");
    await generateNewAddress();
  }

  // Get the ABI from testnet BSC
  Future<DeployedContract> generateContract(String contractName) async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString('./contracts/$contractName.json');
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    // assign contract address
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["97"]["address"]);
    final contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "$contractName"), _contractAddress);
    
    // return deployed contract
    return contract;
  }

  Future<void> generateNewAddress() async {
    Random rng = new Random.secure();
    _credentials = EthPrivateKey.createRandom(rng);
    publicAddress = await _credentials.extractAddress();
  }

  // From the blockchain to the dapp
}
