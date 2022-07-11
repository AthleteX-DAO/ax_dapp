import 'package:ax_dapp/service/Controller/Swap/USDC.dart';
import 'package:ax_dapp/service/Controller/Swap/WETH.dart';
import 'package:ax_dapp/util/SupportedSports.dart';
import 'package:flutter/material.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/APT.dart';
import 'package:ax_dapp/service/Controller/Swap/SXT.dart';
import 'package:ax_dapp/service/Controller/Swap/MATIC.dart';

class TokenList {
  static const Map<int, List<String>> idToAddress = {
    10002087: [
      // Aaron Judge
      "0x19d5b8f926596a31CA1c25cEf8C79A267EDC9864",
      "0x481Bf3dbdE952CE684Dc500Fd9EdEF88f6607A8C",
      "0xA16dd54C674AE300d6DF436E536584eb3AB2F081"
    ], //  0 - pair address, 1 - Long, 2 - Short
    10001365: [
      //Bryce Harper
      "0xD1f6F00a83b1938D697c730dDcad4410F00787De",
      "0x9fd9b5164EAe6E78887beAE74Cbed54D853A6b33",
      "0xBc9095AFF510544846E34926757aCAFd471e0b33"
    ],
    10001918: [
      // Carlos Correa
      "0x53eCe60F883a8C7E16Bb3294808bA589Ab210a6E",
      "0x056A9154d86a994A840935ba995F701370B070F3",
      "0x9229d63a787ab7005E43b716e39096be90F4A77E"
    ],
    10007217: [
      // Fernando Tatis Jr.
      "0x251C607fF5680d5c98761E34464E8Dfe849Ce842",
      "0xFbD2CF33E9aE10bE77AF3A4c3Cac04B4314ceBAc",
      "0x5Ce78a5bA2956895583C4EDf40053E17b2b5744c"
    ],
    10000352: [
      // Jose Ramirez
      "0x34Ca688D00CaAF3a492f46Bc8676c3A48EaBff4e",
      "0xC524e925bdad2419aD31d180300582F7025873dF",
      "0x037fC21641B60e747b46E72F55e1B1337aEB2776"
    ],
    10006794: [
      // Juan Soto
      "0x8ae25fB4fa812395B6d4dD4a4C7ac10D627Ac1fE",
      "0x7057BE5B6E897E910D30178630529643469D9BfB",
      "0xcE44443d4F652fC6c48f62258c75278E11909d6a"
    ],
    10000908: [
      // Marcus Semien
      "0xc98E1EC69D9413c0D74FE6723Dc7D05e3F95dBd0",
      "0xDf40952AAA578272061BD40bEcC125a5a510a62F",
      "0x0860e4C9728E6658F36B314Cdb996CdbD561f8E0"
    ],
    10001009: [
      // Starling Marte
      "0x01c86DeADD7f6993b92D746A53Bab5c8Dd2A97bA",
      "0xa33acF2F8e7CF4e522d0958380d1BC00E42199DB",
      "0xAD9f9A1EBF43725aBEAcb8B9777CBebE42a5693d"
    ],
    10002094: [
      // Trea Turner
      "0x5bB30505Fa69487eC79501a58bb73dEA4D402b80",
      "0x8c5297bC8dFc42Fe4dC5Dd84f3fa8E1dE74D6f66",
      "0x09602a00D9E7a6C93544d74B006739B6D0CF4c1D"
    ],
    10007501: [
      // Vladimir Guerrero Jr.
      "0xbe065AD544D911b101c7393f4e99b43418535daD",
      "0xE91c7952Be8AcbfE6088aAfC50516496273A8aDA",
      "0x37d388321c2cE1E130e36443e8dAE91836a786C0"
    ]
  };

  static const List<List<dynamic>> namesList = [
    ["Aaron Judge", 10002087, "AJLT1010", "AJST1010", SupportedSport.MLB],
    ["Bryce Harper", 10001365, "BHLT1010", "BHST1010", SupportedSport.MLB],
    ["Carlos Correa", 10001918, "CCLT1010", "CCST1010", SupportedSport.MLB],
    [
      "Fernando Tatis Jr.",
      10007217,
      "FTJLT1010",
      "FTJST1010",
      SupportedSport.MLB
    ],
    ["Jose Ramirez", 10000352, "JRLT1010", "JRST1010", SupportedSport.MLB],
    ["Juan Soto", 10006794, "JSLT1010", "JSST1010", SupportedSport.MLB],
    ["Marcus Semien", 10000908, "MSLT1010", "MSST1010", SupportedSport.MLB],
    ["Starling Marte", 10001009, "SMLT1010", "SMST1010", SupportedSport.MLB],
    ["Trea Turner", 10002094, "TTLT1010", "TTST1010", SupportedSport.MLB],
    [
      "Vladimir Guerrero Jr.",
      10007501,
      "VGJLT1010",
      "VGJST1010",
      SupportedSport.MLB
    ],
  ];

  static final List<Token> tokenList = [
    AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
    SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
    MATIC("Matic/Polygon", "Matic",
        AssetImage('assets/images/Polygon_Small.png')),
    WETH("WETH", "WETH", AssetImage('assets/images/weth_small.png')),
    USDC("USDC", "USDC", AssetImage('assets/images/USDC_small.png')),
    ...namesList.map((ath) {
      return APT(
          ath[0] + " Long APT",
          ath[2],
          AssetImage('assets/images/apt_noninverted.png'),
          idToAddress[ath[1]]![1],
          ath[4]);
    }),
    ...namesList.map((ath) {
      return APT(
          ath[0] + " Short APT",
          ath[3],
          AssetImage('assets/images/apt_inverted.png'),
          idToAddress[ath[1]]![2],
          ath[4]);
    }),
  ];
}

class TokenIndex {
  static int get ax => 0;
  static int get sx => 1;
  static int get matic => 2;
  static int get weth => 3;
}

String getLongAptAddress(int id) {
  if (TokenList.idToAddress.containsKey(id)) {
    return TokenList.idToAddress[id]![1];
  }
  return '';
}

String getShortAptAddress(int id) {
  if (TokenList.idToAddress.containsKey(id)) {
    return TokenList.idToAddress[id]![2];
  }
  return '';
}

String getPairAptAddress(int id) {
  if (TokenList.idToAddress.containsKey(id)) {
    return TokenList.idToAddress[id]![0];
  }
  return '';
}

String getLongAthleteSymbol(int id) {
  int longTokenIndex =
      TokenList.namesList.indexWhere((element) => element.contains(id));
  return TokenList.namesList[longTokenIndex][2];
}

String getShortAthleteSymbol(int id) {
  int shortTokenIndex =
      TokenList.namesList.indexWhere((element) => element.contains(id));
  return TokenList.namesList[shortTokenIndex][3];
}
