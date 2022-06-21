import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

class USDC extends Token {
  static String polygonAddress = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
  static String sxAddress = "0x0000000000000000000000000000000000000000";

  USDC(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }
}
