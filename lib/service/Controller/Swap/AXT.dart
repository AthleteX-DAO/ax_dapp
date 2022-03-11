import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';

class AXT extends Token with ERC20Behavior {
  static final String polygonAddress =
      "0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df";
  static final String mumbaiAddress =
      "0x76d9a6e4cdefc840a47069b71824ad8ff4819e85";

  static const Map<int, List<String>> idToAddress = {
    9038: [
      "0xE58d3E98c20CCe8b98715b599ce085E947707596",
      "0xEc460c19f961190f9cEa41f7f7d5419e4bB20708",
      "0x1Cb9dE7932C1F48e600aeC05B1BD7A106B555A2b"
    ], // Matthew Stafford: 0 - pair address, 1 - Long, 2 - Short
    21693: [
      "0x5A5C5D7Ad5E88d77a4fceC5818Dd516aB72F3A6f",
      "0x3F2BA54A0382e41870d63c1AFa1e0422925410Dc",
      "0x1135bCa3382C3861f620739ED7100A4D3f252144"
    ], // Joe Burrow
    22564: [
      "0xc3Ff54B647CA2f1751576ccc52413Ae9cca89996",
      "0x6117A43BAF12327d8A46D8e71222646d63fCe146",
      "0x6Ef3d713F41A18e2c12e1209AdFbA2fF8c6ABA3d"
    ], // Jamaar Chase
    18882: [
      "0xF54d98ec7c61FD26658a31C4FFEeFb69220f0304",
      "0x610410180F162bDb166DFD35DFD11Bb7c1286B5d",
      "0x2Efb4a5eD9128Cf267991b9B90F21f54828417cb"
    ] // Cooper Kupp
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
