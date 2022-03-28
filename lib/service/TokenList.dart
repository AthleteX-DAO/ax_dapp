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
      return APT(ath.name + " Long", ath.name + " Long",
          AssetImage('../assets/images/apt.png'), AXT.idToAddress[ath.id]![1]);
    }),
    ...AthleteList.list.map((ath) {
      return APT(ath.name + " Short", ath.name + " Short",
          AssetImage('../assets/images/apt.png'), AXT.idToAddress[ath.id]![2]);
    }),
  ];

  // TokenList() {
  //   for (Athlete ath in AthleteList.list) {
  //     print("Inside for loop");
  //     print(AXT.idToAddress[ath.id]![1]);
  //     tokenList.add(APT(
  //         ath.name + " Long",
  //         ath.name + " Long",
  //         AssetImage('../assets/images/apt.png'),
  //         AXT.idToAddress[ath.id]![1])); // Long
  //     print(AXT.idToAddress[ath.id]![2]);
  //     tokenList.add(APT(
  //         ath.name + " Short",
  //         ath.name + " Short",
  //         AssetImage('../assets/images/apt.png'),
  //         AXT.idToAddress[ath.id]![2])); // Short
  //   }
  // }
}
