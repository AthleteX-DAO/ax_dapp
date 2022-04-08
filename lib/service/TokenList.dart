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
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ], //  0 - pair address, 1 - Long, 2 - Short
    10001365: [
      //Bryce Harper
      "0xD1f6F00a83b1938D697c730dDcad4410F00787De",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10001918: [
      // Carlos Correa
      "0x53eCe60F883a8C7E16Bb3294808bA589Ab210a6E",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10007217: [
      // Fernando Tatis Jr.
      "0x251C607fF5680d5c98761E34464E8Dfe849Ce842",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10000352: [
      // Jose Ramirez
      "0x34Ca688D00CaAF3a492f46Bc8676c3A48EaBff4e",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10006794: [
      // Juan Soto
      "0x8ae25fB4fa812395B6d4dD4a4C7ac10D627Ac1fE",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10000908: [
      // Marcus Semien
      "0xc98E1EC69D9413c0D74FE6723Dc7D05e3F95dBd0",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10001009: [
      // Starling Marte
      "0x01c86DeADD7f6993b92D746A53Bab5c8Dd2A97bA",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10002094: [
      // Trea Turner
      "0x5bB30505Fa69487eC79501a58bb73dEA4D402b80",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ],
    10007501: [
      // Vladimir Guerrero Jr.
      "0xbe065AD544D911b101c7393f4e99b43418535daD",
      "0x0000000000000000000000000000000000000000",
      "0x0000000000000000000000000000000000000000"
    ]
  };

  static const List<List<dynamic>> namesList = [
    ["Aaron Judge", 10002087],
    ["Bryce Harper", 10001365],
    ["Carlos Correa", 10001918], 
    ["Fernando Tatis Jr.", 10007217], 
    ["Jose Ramirez", 10000352], 
    ["Juan Soto", 10006794], 
    ["Marcus Semien", 10000908], 
    ["Starling Marte", 10001009],  
    ["Trea Turner", 10002094], 
    ["Vladimir Guerrero Jr.", 10007501], 
  ];

  static final List<Token> tokenList = [
    AXT("AthleteX", "AX", AssetImage('assets/images/X_Logo_Black_BR.png')),
    SXT("SportX", "SX", AssetImage('assets/images/SX_Small.png')),
    MATIC("Matic/Polygon", "Matic",
        AssetImage('assets/images/Polygon_Small.png')),
    ...namesList.map((ath) {
      return APT(
          "Long APT",
          ath[0],
          AssetImage('assets/images/apt_noninverted.png'),
          idToAddress[ath[1]]![1]);
    }),
    ...namesList.map((ath) {
      return APT(
          "Short APT",
          ath[0],
          AssetImage('assets/images/apt_inverted.png'),
          idToAddress[ath[1]]![2]);
    }),
  ];
}
