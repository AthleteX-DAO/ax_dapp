// ignore_for_file: implementation_imports, avoid_web_libraries_in_flutter, unused_local_variable

import 'dart:html';
import 'package:get/get.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:flutter/material.dart';

// Token must be swappable
class Token extends GetxController {
  Controller controller = Get.find();
  String name, ticker;
  AssetImage? icon;
  var address = "".obs;
  var amount = 0.0.obs;

  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(this.name, this.ticker, [this.icon]) {
    update();
  }

  updateAddress(String newAddress) {
    address.value = newAddress;
    update();
  }
}
