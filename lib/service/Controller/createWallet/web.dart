import 'dart:html';
import 'package:web3dart/browser.dart';

import 'abstractWallet.dart';
import 'package:web3dart/web3dart.dart';

  DappWallet newWallet() => WebWallet();

  class WebWallet extends DappWallet {
    @override
  Future<void> connect() async {
    final eth = window.ethereum;
    var web3 = Web3Client.custom(eth!.asRpcService());
    credentials = await eth.requestAccount();
  }
  }