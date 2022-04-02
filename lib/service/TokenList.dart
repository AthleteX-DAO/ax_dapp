import 'package:flutter/material.dart';
import 'AthleteList.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/APT.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';

class TokenList {
  static List<Token> tokenList = [
    AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
    SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
    MATIC("Matic/Polygon", "Matic",
        AssetImage('assets/images/Polygon_Small.png')),
    ...AthleteList.list.map((ath) {
      return APT("Long APT", ath.name,
          AssetImage('assets/images/apt_noninverted.png'), AXT.idToAddress[ath.id]![1]);
    }),
    ...AthleteList.list.map((ath) {
      return APT("Short APT", ath.name,
          AssetImage('assets/images/apt_inverted.png'), AXT.idToAddress[ath.id]![2]);
    }),
  ];
}
