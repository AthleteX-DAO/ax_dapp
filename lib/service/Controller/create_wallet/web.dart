// ignore_for_file: avoid_web_libraries_in_flutter, avoid_dynamic_calls

import 'dart:developer';
import 'dart:html';

import 'package:ax_dapp/service/controller/create_wallet/abstract_wallet.dart';
import 'package:erc20/erc20.dart';
import 'package:flutter_web3/flutter_web3.dart' as flutter_web3;
import 'package:http/http.dart';
import 'package:web3_browser/web3_browser.dart';
import 'package:web3dart/web3dart.dart' as web3_dart;

DappWallet newWallet() => WebWallet();

class WebWallet extends DappWallet {
  String mainRPCUrl = 'https://polygon-rpc.com';
  String testRPCUrl = 'https://matic-mumbai.chainstacklabs.com/';

  @override
  Future<void> connect() async {
    if (flutter_web3.Ethereum.isSupported) {
      await switchNetwork();

      client = web3_dart.Web3Client.custom(window.ethereum!.asRpcService());
      credentials = await window.ethereum!.requestAccount();
      publicAddress = credentials.address;
      networkID =
          await web3_dart.Web3Client.custom(window.ethereum!.asRpcService())
              .getNetworkId();
    } else {
      log('Ethereum is not supproted. Please install MetaMask.');
      throw const MetaMaskUnavailableFailure();
    }
  }

  // Comment this for Android
  Future<bool> addTokenToWallet(String tokenAddress, String tokenImage) async {
    // get the ticker and get the decimals
    final tokenEthAddress = web3_dart.EthereumAddress.fromHex(tokenAddress);
    final rpcClient = web3_dart.Web3Client(mainRPCUrl, Client());
    final token = ERC20(address: tokenEthAddress, client: rpcClient);
    final symbol = await token.symbol();
    final decimals = (await token.decimals()).toInt();
    final result = await flutter_web3.ethereum!.walletWatchAssets(
      address: tokenAddress,
      symbol: symbol,
      decimals: decimals,
      image: tokenImage,
    );
    return result;
  }

  Future<int> getTokenDecimal(String tokenAddress) async {
    final tokenEthAddress = web3_dart.EthereumAddress.fromHex(tokenAddress);
    final rpcClient = web3_dart.Web3Client(mainRPCUrl, Client());
    final token = ERC20(address: tokenEthAddress, client: rpcClient);
    final decimals = (await token.decimals()).toInt();
    return decimals;
  }

  Future<void> switchNetwork() async {
    try {
      // switching the chain
      await flutter_web3.ethereum!.walletSwitchChain(137);
      log('MetaMask switched the chain to Polygon mainnet');
    } catch (_) {
      // adding chain to the metamask
      log('The Polygon mainnet is not added on the MetaMask, adding it now...');
      await flutter_web3.ethereum!.walletAddChain(
        chainId: 137,
        chainName: 'Polygon Mainnet',
        nativeCurrency: flutter_web3.CurrencyParams(
          name: 'MATIC Token',
          symbol: 'MATIC',
          decimals: 18,
        ),
        rpcUrls: ['https://rpc-mainnet.matic.quiknode.pro'],
        blockExplorerUrls: ['https://polygonscan.com/'],
      );
      log('The Polygon mainnet has been added and also switched');
    }
  }
}
