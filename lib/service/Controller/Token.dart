import 'package:ae_dapp/service/Controller.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/ERC20.g.dart';

// Token must be swappable
class Token {
  String name, ticker;
  AssetImage? icon;
  EthereumAddress address = EthereumAddress.fromHex("0000000000000000000000000000000000000000");
  late ERC20 erc20;
  get client => Controller.client;
  
  // All ' token ' classes inherit the SAME controller ( super important!!!)
  Token(this.name, this.ticker, [this.icon]);

  Future<BigInt> get balance {
    return erc20.balanceOf(Controller.client);
  }

  void updateERC20(EthereumAddress newAddress) {
    address = newAddress;
    erc20 = ERC20(address: address, client: client);
  }

}
