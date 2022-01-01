import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'Token.dart';

class SXT extends Token {
  static EthereumAddress polygonAddress =
      EthereumAddress.fromHex("0x840195888db4d6a99ed9f73fcd3b225bb3cb1a79");
  static EthereumAddress mumbaiAddress = EthereumAddress.fromHex("0x76d9a6e4cdefc840a47069b71824ad8ff4819e85");

  SXT(String name, String ticker, [AssetImage? icon]) : super(name, ticker) {
    address = mumbaiAddress;
    if (icon != null) {
      super.icon = icon;
    }
    updateERC20(address);
  }

  Future<String> exec(EthereumAddress dest, BigInt amount) {
    // Both need to happen for any transaction
    erc20.approve(dest, amount, credentials: controller.credentials);
    return erc20.transfer(dest, amount, credentials: controller.credentials);
  }
}
