import 'package:ax_dapp/service/controller/token.dart';
import 'package:flutter/material.dart';

class MATIC extends Token {
  MATIC(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }

  static String polygonAddress = '0x0000000000000000000000000000000000001010';
  static String mumbaiAddress = '0x0000000000000000000000000000000000001010';
}
