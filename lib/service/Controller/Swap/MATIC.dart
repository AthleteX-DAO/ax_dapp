import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

class MATIC extends Token {
  static String polygonAddress = "0x0000000000000000000000000000000000001010";
  static String mumbaiAddress = "0x0000000000000000000000000000000000001010";

  MATIC(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, mumbaiAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }
}
