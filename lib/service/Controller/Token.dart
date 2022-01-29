// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, unused_local_variable

// import 'dart:html';
import 'package:get/get.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

// Token must be swappable
class Token extends GetxController {
  Controller controller = Get.find();
  late Erc20 erc20;
  String name, ticker;
  AssetImage? icon;
  var address = "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85".obs;
  var amount = 0.0.obs;
  var balance = BigInt.zero.obs;
  var totalSupply = BigInt.zero.obs;

  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(this.name, this.ticker, [this.icon]) {
    EthereumAddress ethAddress = EthereumAddress.fromHex(address.value);
    erc20 = Erc20(address: ethAddress, client: controller.client.value);
    update();
  }

  updateAddress(String newAddress) {
    address.value = newAddress;
    update();
  }
}
