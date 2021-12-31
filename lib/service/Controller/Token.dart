import 'dart:html';
import 'package:get/get.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/src/browser/javascript.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/browser.dart';
import 'package:web3dart/web3dart.dart';

// Token must be swappable
class Token extends GetxController {
  Controller controller = Get.find();
  String name, ticker;
  BigInt balance = BigInt.zero;
  AssetImage? icon;
  num? amount;
  var address =
      EthereumAddress.fromHex("0000000000000000000000000000000000000000");
  late Erc20 erc20;
  get client => controller.client;

  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(this.name, this.ticker, [this.icon]) {
    erc20 = Erc20(address: address, client: client);
    updateBalance();
  }

  Future<void> updateBalance() async {
    balance = await erc20.balanceOf(controller.publicAddress);
    update();
  }

  void updateERC20(EthereumAddress newAddress) {
    address = newAddress;
    erc20 = Erc20(address: address, client: client);
    update();
  }

  Future<String> approve(EthereumAddress dest, double amount) {
    // Both need to happen for any transaction
    BigInt amountToApprove = BigInt.from(amount);
    return erc20.approve(dest, amountToApprove,
        credentials: controller.credentials);
  }

  static void addToWallet() {
    final eth = window.ethereum;
    RequestArguments paramArgs = RequestArguments(method: 'wallet_watchAsset');
    eth!.rawRequest('wallet_watchAsset', params: {});
  }
}
