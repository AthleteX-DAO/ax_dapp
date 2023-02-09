// ignore_for_file: only_throw_errors

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class Controller {
  late Credentials credentials;
  static String latestTransaction = '';
  
  Rx<Web3Client> client = Web3Client('https://polygon-rpc.com', Client()).obs;

  // ignore: avoid_setters_without_getters
  set axTokenAddress(EthereumAddress tokenAddress) =>
      axTokenAddress = EthereumAddress.fromHex(tokenAddress.hex);

  // ignore: avoid_setters_without_getters
  set transactionHash(String transaction) => latestTransaction = transaction;

  // ignore: avoid_setters_without_getters
  set transactionHashString(String transaction) => latestTransaction = transaction;

  static Future<void> viewTx() async {
    var urlString = Uri.parse('');
    latestTransaction == ''
        ? urlString = Uri.parse('https://polygonscan.com')
        : urlString = Uri.parse('https://polygonscan.com/tx/$latestTransaction');
    await launchUrl(urlString);
  }
}
