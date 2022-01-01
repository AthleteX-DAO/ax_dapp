import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'Token.dart';

class SXT extends Token with ERC20Behavior {
  static String polygonAddress = "0x840195888db4d6a99ed9f73fcd3b225bb3cb1a79";
  static String mumbaiAddress = "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85";

  SXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    updateAddress(mumbaiAddress);
    if (icon != null) {
      super.icon = icon;
    }
  }
}
