// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:erc20/erc20.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as Web3Dart;
import 'abstractWallet.dart';
import 'package:flutter_web3/flutter_web3.dart' as FlutterWeb3;
import 'package:web3_browser/web3_browser.dart';

DappWallet newWallet() => WebWallet();

class WebWallet extends DappWallet {
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

  @override
  Future<void> connect() async {
    if (FlutterWeb3.Ethereum.isSupported) {
      await this.switchNetwork();

      this.client = Web3Dart.Web3Client.custom(window.ethereum!.asRpcService());
      this.credentials = await window.ethereum!.requestAccount();
      this.publicAddress = credentials.address;
      this.networkID = await Web3Dart.Web3Client.custom(window.ethereum!.asRpcService()).getNetworkId();
      print("[Console] This is the public address: ${this.publicAddress}, and network: ${this.networkID}");
      print("[Console] This is the credentials type: ${this.credentials.toString()}");
    } else {
      print("[Console] Ethereum is not supproted. Please install MetaMask.");
    }
  }

  //Comment this for Android
  Future<bool> addTokenToWallet(String tokenAddress) async {
    print("[Console] - Current Address: $tokenAddress");
    // get the ticker and get the decimals
    Web3Dart.EthereumAddress tokenEthAddress = Web3Dart.EthereumAddress.fromHex(tokenAddress);
    Web3Dart.Web3Client rpcClient = Web3Dart.Web3Client(mainRPCUrl, Client());
    ERC20 token = ERC20(address: tokenEthAddress, client: rpcClient);
    String symbol = await token.symbol();
    print('[Console] - $symbol');
    int decimals = (await token.decimals()).toInt();
    print('[Console] - $decimals');
    bool result = await FlutterWeb3.ethereum!.walletWatchAssets(
        address: tokenAddress,
        symbol: symbol,
        decimals: decimals);
    print("[Console] Result of adding AX token to MetaMask. {$result}");
    return result;
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
}
