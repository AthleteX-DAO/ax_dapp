import 'package:ax_dapp/service/controller/erc20_behavior.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:flutter/material.dart';

class AXT extends Token with ERC20Behavior {
  AXT(String name, String ticker, [AssetImage? icon])
      : super(name, ticker, polygonAddress) {
    if (icon != null) {
      super.icon = icon;
    }
  }

  static const String polygonAddress =
      '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df';
  static const String mumbaiAddress =
      '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85';

  void getLatestPrice() {}
}
