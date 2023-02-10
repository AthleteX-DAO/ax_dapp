import 'package:ax_dapp/wallet/bloc/wallet_bloc.dart';
import 'package:flutter/foundation.dart';
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
  set transactionHashString(String transaction) =>
      latestTransaction = transaction;

  static Future<void> viewTx(EthereumChain chain) async {
    final transactionHashUrl =
        '${chain.blockExplorerUrls![0]}tx/$latestTransaction';
    debugPrint('THIS IS THE TRANSACTION HASH URL -> $transactionHashUrl');
    await launchUrl(Uri.parse(transactionHashUrl));
  }
}
