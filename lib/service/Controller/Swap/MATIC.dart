import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:flutter/material.dart';

class MATIC extends Token {
  static String polygonAddress = "0x0000000000000000000000000000000000001010";

  MATIC(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }
}
