
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'Token.dart';

class AXT extends Token{
  String axName = "";

  static final EthereumAddress polygonAddress =
      EthereumAddress.fromHex("0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df");
  static final EthereumAddress mumbaiAddress =
      EthereumAddress.fromHex("0x76d9a6e4cdefc840a47069b71824ad8ff4819e85");

  AXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    address = mumbaiAddress;
    if (icon != null) {
      super.icon = icon;
    }
    updateERC20(address);
  }
}
