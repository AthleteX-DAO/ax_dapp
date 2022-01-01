import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'Token.dart';

class AXT extends Token with ERC20Behavior {
  static final String polygonAddress =
      "0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df";
  static final String mumbaiAddress =
      "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85";

  AXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    updateAddress(mumbaiAddress);
    if (icon != null) {
      super.icon = icon;
    }
  }
}
