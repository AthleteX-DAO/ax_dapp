// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, unused_local_variable

import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:erc20/erc20.dart';
import 'package:get/get.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

// Token must be swappable
class Token extends GetxController {
  Controller controller = Get.find();
  late ERC20 erc20;
  late EthereumAddress ethAddress;
  String name, ticker;
  AssetImage? icon;
  var address = "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85".obs;
  var amount = 0.0.obs;
  var balance = BigInt.zero.obs;
  var totalSupply = BigInt.zero.obs;
  SupportedSport sport = SupportedSport.ALL;

  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(this.name, this.ticker, tokenAddress,
      [this.icon, this.sport = SupportedSport.ALL]) {
    updateAddress(tokenAddress);
    ethAddress = EthereumAddress.fromHex(address.value);
    erc20 = ERC20(address: ethAddress, client: controller.client.value);
    update();
  }

  updateAddress(String newAddress) {
    address.value = newAddress;
    update();
  }
}
