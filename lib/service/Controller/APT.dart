import 'package:ax_dapp/service/controller/apt_behavior.dart';
import 'package:ax_dapp/service/controller/erc20_behavior.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

// Composition & Has-A relationship not Is-A relationship

class APT extends Token with APTBehavior, ERC20Behavior {
  APT(
    String name,
    String ticker,
    AssetImage? icon,
    String aptAddress,
    SupportedSport sport,
  ) : super(name, ticker, aptAddress, icon, sport);

  late final EthereumAddress tokenContract; //EMP

  EthereumAddress? optionsContract; //LSP

  dynamic bookPrice, marketPrice;
}
