import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

// State management
class Controller extends ChangeNotifier {
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
  DeployedContract empCreator, registry, identifierWhitelist, staking;

  // No-args constructor
  Controller() {
    initialSetup();
  }

  initialSetup() async {
    // Setup connection between eth rpc node & dApp
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    // Setup the contracts we'll be using - they're immutable so can be called once
    empCreator = await retrieveContract("ExpiringMultiParyCreator");
    registry = await retrieveContract("Registry");
    identifierWhitelist = await retrieveContract("IdentifierWhiteList");
    staking = await retrieveContract("Staking");
    await retrieveNewAddress();
  }

  // Get the ABI from testnet BSC
  Future<DeployedContract> retrieveContract(String contractName) async {
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

  Future<void> retrieveNewAddress() async {
    Random rng = new Random.secure();
    _credentials = EthPrivateKey.createRandom(rng);
    publicAddress = await _credentials.extractAddress();
  }

  Credentials getCredentials() {
    return _credentials;
  }

  dynamic getBalance() async {
    ContractFunction stakeOf = staking.function("stakeOf");
    final balance = await _client
        .call(contract: staking, function: stakeOf, params: [11 * 18]);
    return balance;
  }

  // dynamic stake(int amount) async {
  //   ContractFunction stake = staking.function("createStake");
    
  // }

  Future<void> createAthleteTokenContract(String params) async {
    ContractFunction createEMP =
        empCreator.function("createExpiringMultiParty");
  }

  // From the blockchain to the dapp
}
