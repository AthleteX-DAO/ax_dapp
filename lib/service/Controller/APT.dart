import 'package:ax_dapp/service/Controller/APTBehavior.dart';
import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
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
