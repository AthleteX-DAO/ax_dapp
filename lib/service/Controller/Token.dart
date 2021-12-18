import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/ERC20.g.dart';

// Token must be swappable
class Token {
  String name, ticker;
  AssetImage icon;
  static var address;
  late ERC20 erc20;
  // All ' token ' classes inherit the SAME controller ( super important!!!)

  Token(this.name, this.ticker, this.icon);

  factory Token(this.name, this.ticker) {
    ERC20(address: address, client: Controller.client);
  }

  // Has-A composition
  get client => Controller.client;
  instantiate() {
    erc20 = ERC20(address: address, client: client);
    return Erc20(address: address, client: client);
  }

  swap() {}
  createPair() {}
}
