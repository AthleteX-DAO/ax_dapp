import 'dart:io';

import 'dart:math';
import 'package:ae_dapp/pages/wallet.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

const String rpcURL = "https://bsc-dataseed.binance.org/";
Future<void> main() async {
  final client = Web3Client(rpcURL, Client());
  Random random = new Random.secure();
  Credentials credentials = EthPrivateKey.createRandom(random);
  final myAddress = await credentials.extractAddress();
}

class ClientController {
  Web3Client _client;

  ClientController() {
    init();
  }

  init() async {

  }
}
