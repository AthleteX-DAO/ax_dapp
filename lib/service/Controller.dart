import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart'; //Reference Library https://pub.dev/packages/web3dart/example
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/
import 'package:web_socket_channel/io.dart';

// State management
Controller c = Controller();

class Controller {
  // RPC & WS are now linked to MATIC-Testnet

  late JsonRpcProvider rpcProvider;
  final String _rpcUrl = 'https://rpc-mumbai.matic.today';
  final String _wsUrl = 'wss://rpc-mumbai.matic.today';
  static const OPERATING_CHAIN = 80001;
  String currentAddress = '';
  int currentChain = -1;
  bool wcConnected = false;
  final wc = WalletConnectProvider.fromRpc({80001: 'https://rpc-mumbai.matic.today'}, chainId: OPERATING_CHAIN, network: 'Mumbai');

  // ignore: avoid_init_to_null
  Web3Provider? _web3wc;
  // final Contract staking = Contract(
  //     "0x063086C5b352F986718Db9383c894Be9Cd4350fA", abi, provider!.getSigner());
  final ContractERC20 _axToken =
      ContractERC20("0x585E0c93F73C520ca6513fc03f450dAea3D4b493", ethereum!);

  // No-args constructor
  Controller() {
    rpcProvider = JsonRpcProvider(_rpcUrl);
    _web3wc = Web3Provider(Ethereum.provider);
  }

  // Getters
  Web3Provider? get web3wc => _web3wc;
  ContractERC20 get axToken => _axToken;
  bool get isInOperatingChain => currentChain == OPERATING_CHAIN;
  bool get isConnected => Ethereum.isSupported && currentAddress.isNotEmpty;

  connectProvider() async {
    if (Ethereum.isSupported) {
      final accs = await ethereum!.requestAccount();
      if (accs.isNotEmpty) {
        currentAddress = accs.first;
        currentChain = await ethereum!.getChainId();
      }
    }
  }

  connectWC() async {
    await wc.connect();
    if (wc.connected) {
      currentAddress = wc.accounts.first;
      currentChain = 56;
      wcConnected = true;
      _web3wc = Web3Provider.fromWalletConnect(wc);
    }
  }

  clear() {
    currentAddress = '';
    currentChain = -1;
    wcConnected = false;
    _web3wc = null;
  }

  init() {
    if (Ethereum.isSupported) {
      connectProvider();

      ethereum!.onAccountsChanged((accs) {
        clear();
      });

      ethereum!.onChainChanged((chain) {
        clear();
      });
    }
  }

  getLastestBlock() async {
    print(await provider!.getLastestBlock());
    print(await provider!.getLastestBlockWithTransaction());
  }

  testProvider() async {
    final rpcProvider = JsonRpcProvider('https://bsc-dataseed.binance.org/');
    print(rpcProvider);
    print(await rpcProvider.getNetwork());
  }

  test() async {}

  testSwitchChain() async {
    await ethereum!.walletSwitchChain(97, () async {
      await ethereum!.walletAddChain(
        chainId: 97,
        chainName: 'Binance Testnet',
        nativeCurrency:
            CurrencyParams(name: 'BNB', symbol: 'BNB', decimals: 18),
        rpcUrls: ['https://data-seed-prebsc-1-s1.binance.org:8545/'],
      );
    });
  }

}
