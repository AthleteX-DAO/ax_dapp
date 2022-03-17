import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

class AXT extends Token with ERC20Behavior {
  static final String polygonAddress =
      "0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df";
  static final String mumbaiAddress =
      "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85";

  static const idToAddress = {
    9038: "0xE58d3E98c20CCe8b98715b599ce085E947707596", // Matthew Stafford
    21693: "0x5A5C5D7Ad5E88d77a4fceC5818Dd516aB72F3A6f", // Joe Burrow
    22564: "0xc3Ff54B647CA2f1751576ccc52413Ae9cca89996", // Jamaar Chase
    18882: "0xF54d98ec7c61FD26658a31C4FFEeFb69220f0304" // Cooper Kupp
  };

  AXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    updateAddress(mumbaiAddress);
    updateERC20(mumbaiAddress);
    if (icon != null) {
      super.icon = icon;
    }
  }

  void getLatestPrice() {}
}
