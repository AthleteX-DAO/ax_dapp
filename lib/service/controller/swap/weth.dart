import 'package:ax_dapp/service/controller/token.dart';
import 'package:flutter/material.dart';

class WETH extends Token {
  WETH(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }

  static String polygonAddress = '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619';
  static String sxAddress = '0x0000000000000000000000000000000000000000';
}
