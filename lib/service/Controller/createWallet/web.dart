// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:erc20/erc20.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as Web3Dart;
import 'package:web3dart/web3dart.dart';
import 'abstractWallet.dart';
import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;
import 'package:web3_browser/web3_browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

DappWallet newWallet() => WebWallet();

class WebWallet extends DappWallet {
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

  @override
  Future<void> connect({String? rpcUrl}) async {
    const POLYGON_RPC = 'https://polygon-rpc.com';

    if (rpcUrl == null) {
      rpcUrl = POLYGON_RPC;
    }

    if (seedHex == null) {
      this.createNewMnemonic();
    }

    this.client = Web3Client(rpcUrl, Client());
    this.credentials = EthPrivateKey.fromHex(seedHex);
    this.publicAddress = await credentials.extractAddress();
    print('Credentials $credentials, Public Address $publicAddress');
    this.networkID = await client.getNetworkId();
    print("[Console] updated client and credentials at $publicAddress");
  }

  Future<void> connectwithMetamask() async {
    if (FlutterWeb3.Ethereum.isSupported) {
      await this.switchNetwork();
      // Anything with the 'ethereum' object is not allowed
      this.client = Web3Dart.Web3Client.custom(window.ethereum!.asRpcService());
      this.credentials = await window.ethereum!.requestAccount();
      this.publicAddress = credentials.address;
      this.networkID =
          await Web3Dart.Web3Client.custom(window.ethereum!.asRpcService())
              .getNetworkId();
      print(
          "[Console] This is the public address: ${this.publicAddress}, and network: ${this.networkID}");
      print(
          "[Console] This is the credentials type: ${this.credentials.toString()}");
    } else {
      print("[Console] Ethereum is not supproted. Please install MetaMask.");
    }
  }

  //Comment this for Android
  Future<bool> addTokenToWallet(String tokenAddress, String tokenImage) async {
    print("[Console] - Current Address: $tokenAddress");
    // get the ticker and get the decimals
    Web3Dart.EthereumAddress tokenEthAddress =
        Web3Dart.EthereumAddress.fromHex(tokenAddress);
    Web3Dart.Web3Client rpcClient = Web3Dart.Web3Client(mainRPCUrl, Client());
    ERC20 token = ERC20(address: tokenEthAddress, client: rpcClient);
    String symbol = await token.symbol();
    print('[Console] - $symbol');
    int decimals = (await token.decimals()).toInt();
    print('[Console] - $decimals');
    bool result = await FlutterWeb3.ethereum!.walletWatchAssets(
        address: tokenAddress,
        symbol: symbol,
        decimals: decimals,
        image: tokenImage);
    print("[Console] Result of adding AX token to MetaMask. {$result}");
    return result;
  }

  Future<int> getTokenDecimal(String tokenAddress) async {
    Web3Dart.EthereumAddress tokenEthAddress =
        Web3Dart.EthereumAddress.fromHex(tokenAddress);
    Web3Dart.Web3Client rpcClient = Web3Dart.Web3Client(mainRPCUrl, Client());
    ERC20 token = ERC20(address: tokenEthAddress, client: rpcClient);
    int decimals = (await token.decimals()).toInt();
    return decimals;
  }

  Future<void> switchNetwork() async {
    print("Inside switchNetwork()");

    try {
      // switching the chain
      await FlutterWeb3.ethereum!.walletSwitchChain(137);
      print("[Console] MetaMask swtiched the chain to Polygon mainnet");
    } catch (err) {
      // adding chain to the metamask
      print("[Console] The Polygon mainnet is not added on the MetaMask");
      await FlutterWeb3.ethereum!.walletAddChain(
          chainId: 137,
          chainName: 'Polygon Mainnet',
          nativeCurrency: FlutterWeb3.CurrencyParams(
              name: 'MATIC Token', symbol: 'MATIC', decimals: 18),
          rpcUrls: ['https://rpc-mainnet.matic.quiknode.pro'],
          blockExplorerUrls: ['https://polygonscan.com/']);
      print("[Console] The Polygon mainnet is added and also switched");
    }
  }

  void createNewMnemonic() {
    this.mnemonic = bip39.generateMnemonic();
    this.seedHex = bip39.mnemonicToSeedHex(mnemonic);
  }

// This will import mnemonics & convert to seed hexes
  Future<bool> importMnemonic(String _mnemonic) async {
    // validate if mnemonic
    bool isValidMnemonic = bip39.validateMnemonic(_mnemonic);
    if (isValidMnemonic) {
      this.seedHex = bip39.mnemonicToSeedHex(_mnemonic);
      this.mnemonic = _mnemonic;
    }
    return isValidMnemonic;
  }
}
