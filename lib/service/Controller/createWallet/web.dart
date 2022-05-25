// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
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
  Future<bool> addTokenToWallet() async {
    print("[Console] Adding AX token to MetaMask wallet");
    bool result = await FlutterWeb3.ethereum!.walletWatchAssets(
        address: "0x5617604BA0a30E0ff1d2163aB94E50d8b6D0B0Df",
        symbol: "AX",
        decimals: 18);
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
