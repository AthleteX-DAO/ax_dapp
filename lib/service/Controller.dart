import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web3_provider/ethereum.dart';
import 'package:flutter_web3_provider/ethers.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart'; //Reference Library https://pub.dev/packages/web3dart/example
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/
import 'package:web_socket_channel/io.dart';

// State management
Controller c = Controller();

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  // private client for web3dart
  bool isLoading = true;
  // Eth related variable declarations

  // ignore: avoid_init_to_null
  late String _abiCode, privateAddress, userMnemonic;
  late EthereumAddress _contractAddress, _publicAddress;
  late Credentials _credentials;
  late Web3Client _client;
  late Web3Provider _web3;
  late final DeployedContract staking;

  // No-args constructor
  Controller() {
    initialSetup();
    _web3 = Web3Provider(ethereum!);
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
  }

  // Getters
  Web3Client get client => _client;
  Web3Provider get web3 => _web3;
  Credentials get credentials => _credentials;
  EthereumAddress get publicAddress => _publicAddress;

  initialSetup() async {
    // Setup connection between eth rpc node & dApp

    // Automatically create a wallet upon instantiation
    // await createWallet();
  }

  // Get the ABI from testnet BSC
  Future<DeployedContract> _retrieveContract(String contractName) async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString('../../contracts/$contractName.json');
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    // assign contract address
    _contractAddress = EthereumAddress.fromHex(
        jsonAbi["networks"]["80001"]["address"]); //BSC-TESTNET Address
    final contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "$contractName"), _contractAddress);

    // return deployed contract
    return contract;
  }

  Future<String> getMnemonic() async {
    // Generate a random mnemonic (uses crypto.randomBytes under the hood), defaults to 128-bits of entropy
    return (userMnemonic);
  }

  Future<void> createWallet([String? mnemonic]) async {
    // If user comes with a mnemonic seed
    var seed;
    if (mnemonic == null) {
      var validMnemonic;
      validMnemonic = bip39.generateMnemonic();
      seed = bip39.mnemonicToSeedHex(validMnemonic);
      _credentials = EthPrivateKey.fromHex(seed);
      mnemonic = validMnemonic;
    } else {
      seed = bip39.mnemonicToSeedHex(mnemonic);
      _credentials = EthPrivateKey.fromHex(seed);
    }

    // stores private / public keypair
    privateAddress = seed;
    userMnemonic = mnemonic!;
  }

  Future<EthereumAddress> getPublicAddress() async {
    // Is this below necessary?
    EthereumAddress pAddress = await _credentials.extractAddress();
    return pAddress;
  }
}
