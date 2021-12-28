import 'package:ae_dapp/contracts/AthleteX.g.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../Controller.dart';
import 'Token.dart';

class AXT extends Token {
  static EthereumAddress polygonAddress =
      EthereumAddress.fromHex("0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df");
  static EthereumAddress mumbaiAddress = EthereumAddress.fromHex("0x76d9a6e4cdefc840a47069b71824ad8ff4819e85");

  AXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    address = mumbaiAddress;
    if (icon != null) {
      super.icon = icon;
    }
    updateERC20(address);
  }

  Future<String> exec(EthereumAddress dest, BigInt amount) {
    // Both need to happen for any transaction
    erc20.approve(dest, amount, credentials: Controller.credentials);
    return erc20.transfer(dest, amount, credentials: Controller.credentials);
  }
}
