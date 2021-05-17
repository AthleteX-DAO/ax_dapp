import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart'; //Reference Library https://pub.dev/packages/web3dart/example
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
    empCreator = await retrieveContract("ExpiringMultiPartyCreator");
    registry = await retrieveContract("Registry");
    identifierWhitelist = await retrieveContract("IdentifierWhitelist");
    staking = await retrieveContract("Staking");
    await retrieveNewAddress();
  }

  // Get the ABI from testnet BSC
  Future<DeployedContract> retrieveContract(String contractName) async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString('contracts/$contractName.json');
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    // assign contract address
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["97"]["address"]); //BSC-TESTNET Address
    final contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "$contractName"), _contractAddress);

    // return deployed contract
    return contract;
  }

  Future<EthereumAddress> retrieveNewAddress() async {
    Random rng = new Random.secure();
    _credentials = EthPrivateKey.createRandom(rng);
    publicAddress = await _credentials.extractAddress();
    return publicAddress;
  }

  Credentials getCredentials() {
    return _credentials;
  }

  ///** Mutataive Methods */
  
  // Staking
  Future<BigInt> getStakeBalance(EthereumAddress from) async {
    
    ContractFunction stakeOf = staking.function("stakeOf");
    var balance = await _client
        .call(contract: staking, function: stakeOf, params: [from]);
    return balance.first as BigInt;
  }

  Future<String> stake(BigInt stakeAmount) async {
    ContractFunction createStake = staking.function("createStake");
    return await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: staking,
            function: createStake,
            parameters: [stakeAmount]),
        chainId: 97,
        fetchChainIdFromNetworkId: true);
  }

  Future<String> withdraw(BigInt withdrawAmount) async {

    ContractFunction removeStake = staking.function("removeStake");
    return await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: staking,
            function: removeStake,
            parameters: [withdrawAmount]),
            chainId: 97,
            fetchChainIdFromNetworkId: true);
  }

  // Creating tokens
  Future<void> createAthleteTokenContract() async {
    ContractFunction createEMP =
        empCreator.function("createExpiringMultiParty");

    // Create a new emp from the factory instance
  }

  // From the blockchain to the dapp
}

class Params {
  EthereumAddress collateralAddress, financialProductLibraryAddress;
  BigInt expirationTimestamp;
  String syntheticName, syntheticSymbol;
  Map<dynamic, dynamic> constructorParams;

  constructParams() {
    // var constructorParams = {
    //   expirationTimestamp: "1706780800",
    //   collateralAddress: TestnetERC20.address,
    //   priceFeedIdentifier:
    //       web3.utils.padRight(web3.utils.utf8ToHex("UMATEST"), 64),
    //   syntheticName: "Test UMA Token",
    //   syntheticSymbol: "UMATEST",
    //   collateralRequirement: {rawValue: web3.utils.toWei("1.5")},
    //   disputeBondPercentage: {rawValue: web3.utils.toWei("0.1")},
    //   sponsorDisputeRewardPercentage: {rawValue: web3.utils.toWei("0.1")},
    //   disputerDisputeRewardPercentage: {rawValue: web3.utils.toWei("0.1")},
    //   minSponsorTokens: {rawValue: '100000000000000'},
    //   timerAddress: Timer.address,
    //   withdrawalLiveness: 7200,
    //   liquidationLiveness: 7200,
    //   financialProductLibraryAddress:
    //       '0x0000000000000000000000000000000000000000'
    // };
    print("params");
  }
}
