// ignore_for_file: implementation_imports
// ignore_for_file: avoid_web_libraries_in_flutter
// ignore_for_file: unused_local_variable

import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:erc20/erc20.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

// Token must be swappable
class Token extends GetxController {
  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(
    this.name,
    this.ticker,
    String tokenAddress, [
    this.icon,
    this.sport = SupportedSport.all,
  ]) {
    updateAddress(tokenAddress);
    ethAddress = EthereumAddress.fromHex(address.value);
    erc20 = ERC20(address: ethAddress, client: controller.client.value);
    update();
  }
  Controller controller = Get.find();
  late ERC20 erc20;
  late EthereumAddress ethAddress;
  String name, ticker;
  AssetImage? icon;
  RxString address = '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85'.obs;
  RxDouble amount = 0.0.obs;
  Rx<BigInt> balance = BigInt.zero.obs;
  Rx<BigInt> totalSupply = BigInt.zero.obs;
  SupportedSport sport = SupportedSport.all;

  void updateAddress(String newAddress) {
    address.value = newAddress;
    update();
  }
}
