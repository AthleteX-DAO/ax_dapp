import 'package:ax_dapp/service/Controller/Swap/SupportedChain.dart';
import 'package:ax_dapp/service/Controller/Swap/USDC.dart';
import 'package:ax_dapp/service/Controller/Swap/WETH.dart';
import 'package:ax_dapp/service/TokenListMumbai.dart';
import 'package:ax_dapp/service/TokenListPolygon.dart';
import 'package:ax_dapp/util/ChainManager.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/APT.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';

class TokenListManager {
  static const List<List<dynamic>> namesList = [
    ["Aaron Judge", 10002087, "AJLT1010", "AJST1010"],
    ["Bryce Harper", 10001365, "BHLT1010", "BHST1010"],
    ["Carlos Correa", 10001918, "CCLT1010", "CCST1010"],
    ["Fernando Tatis Jr.", 10007217, "FTJLT1010", "FTJST1010"],
    ["Jose Ramirez", 10000352, "JRLT1010", "JRST1010"],
    ["Juan Soto", 10006794, "JSLT1010", "JSST1010"],
    [
      "Marcus Semien",
      10000908,
      "MSLT1010",
      "MSST1010",
    ],
    ["Starling Marte", 10001009, "SMLT1010", "SMST1010"],
    ["Trea Turner", 10002094, "TTLT1010", "TTST1010"],
    ["Vladimir Guerrero Jr.", 10007501, "VGJLT1010", "VGJST1010"],
  ];

  static List<Token> getTokenList() {
    Map<int, List<String>> idToAddress =
        mapChainToList(ChainManager.getSelectedChain());
    List<Token>tokenList = [
      AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
      SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
      MATIC("Matic/Polygon", "Matic",
          AssetImage('assets/images/Polygon_Small.png')),
      WETH("WETH", "WETH", AssetImage('images/weth_small.png')),
      USDC("USDC", "USDC", AssetImage('images/USDC_small.png')),
      ...namesList.map((ath) {
        return APT(
            ath[0] + " Long APT",
            ath[2],
            AssetImage('assets/images/apt_noninverted.png'),
            idToAddress[ath[1]]![1]);
      }),
      ...namesList.map((ath) {
        return APT(
            ath[0] + " Short APT",
            ath[3],
            AssetImage('assets/images/apt_inverted.png'),
            idToAddress[ath[1]]![2]);
      }),
    ];
    return tokenList;
  }

  static Map<int, List<String>> mapChainToList(SupportedChain currentChain) {
    switch (currentChain) {
      case SupportedChain.MATIC:
        return TokenListPolygon.idToAddress;
      default:
        return TokenListMumbai.idToAddress;
    }
  }
}

String getLongAptAddress(int id) {
  Map<int, List<String>> idToAddress =
        TokenListManager.mapChainToList(ChainManager.getSelectedChain());
  if (idToAddress.containsKey(id)) {
    return idToAddress[id]![1];
  }
  return '';
}

String getShortAptAddress(int id) {
  Map<int, List<String>> idToAddress =
        TokenListManager.mapChainToList(ChainManager.getSelectedChain());
  if (idToAddress.containsKey(id)) {
    return idToAddress[id]![2];
  }
  return '';
}

String getPairAptAddress(int id) {
  Map<int, List<String>> idToAddress =
        TokenListManager.mapChainToList(ChainManager.getSelectedChain());
  if (idToAddress.containsKey(id)) {
    return idToAddress[id]![0];
  }
  return '';
}
