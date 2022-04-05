// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';
import 'package:web3dart/browser.dart';

import 'abstractWallet.dart';
import 'package:web3dart/web3dart.dart';

  DappWallet newWallet() => WebWallet();

  class WebWallet extends DappWallet {

    String mainRPCUrl = "https://polygon-rpc.com";
    String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

    @override
  Future<void> connect() async {
    final eth = window.ethereum;
    this.client = Web3Client.custom(eth!.asRpcService());
    credentials = await eth.requestAccount();
  }
    //Comment this for Android
    void addTokenToWallet() async {
      final eth = window.ethereum;
      Object tokenParam = {
        "type": "ERC20",
        "options": {
          "address": "0xb60e8dd61c5d32be8058bb8...",
          "symbol": "FOO",
          "decimals": 18,
          "image": "https: //foo.io/token-ima..."
        }
      };

      eth!.rawRequest('wallet_watchAsset', params: tokenParam);
    }

    Future<bool> switchNetwork() async {
      print("Inside switchNetwork()");
      final eth = window.ethereum;
      Object switchParams = [
        {'chainId': '0x89'}
      ];
      try {
        print("[Console] Trying to switch the network");
        await eth!.rawRequest('wallet_switchEthereumChain', params: switchParams);
        print("[Console] Switched the network to mainnet(137, 0x89?)");
        return true;
      } catch (error) {
        print("[Console] Main network not installed on MetaMask");
        try {
          Object addParams = [
            {
              'chainId': '0x89',
              'chainName': 'Matic(Mainnet)',
              'rpcUrls': mainRPCUrl,
            }
          ];
          await eth!.rawRequest('wallet_addEthereumChain', params: addParams);
          print("[Console] Added a mainnet to the MetaMask");
          return true;
        } catch (addError) {
          print("[Console] Could not add a mainnet to the MetaMask");
          return false;
        }
      }
    }
  }