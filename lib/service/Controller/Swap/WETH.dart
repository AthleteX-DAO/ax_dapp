import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

class WETH extends Token {
  static String polygonAddress = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";
  static String sxAddress = "0x0000000000000000000000000000000000000000";

  WETH(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }
}