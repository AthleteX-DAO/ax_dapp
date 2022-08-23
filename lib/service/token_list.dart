import 'package:ax_dapp/service/controller/apt.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/controller/swap/matic.dart';
import 'package:ax_dapp/service/controller/swap/sxt.dart';
import 'package:ax_dapp/service/controller/swap/usdc.dart';
import 'package:ax_dapp/service/controller/swap/weth.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TokenList {
  static const Map<int, List<String>> idToAddress = {
    10002087: [
      // Aaron Judge
      '0x19d5b8f926596a31CA1c25cEf8C79A267EDC9864',
      '0x481Bf3dbdE952CE684Dc500Fd9EdEF88f6607A8C',
      '0xA16dd54C674AE300d6DF436E536584eb3AB2F081'
    ], //  0 - pair address, 1 - Long, 2 - Short
    10001365: [
      //Bryce Harper
      '0xD1f6F00a83b1938D697c730dDcad4410F00787De',
      '0x9fd9b5164EAe6E78887beAE74Cbed54D853A6b33',
      '0xBc9095AFF510544846E34926757aCAFd471e0b33'
    ],
    10001918: [
      // Carlos Correa
      '0x53eCe60F883a8C7E16Bb3294808bA589Ab210a6E',
      '0x056A9154d86a994A840935ba995F701370B070F3',
      '0x9229d63a787ab7005E43b716e39096be90F4A77E'
    ],
    10007217: [
      // Fernando Tatis Jr.
      '0x251C607fF5680d5c98761E34464E8Dfe849Ce842',
      '0xFbD2CF33E9aE10bE77AF3A4c3Cac04B4314ceBAc',
      '0x5Ce78a5bA2956895583C4EDf40053E17b2b5744c'
    ],
    10000352: [
      // Jose Ramirez
      '0x34Ca688D00CaAF3a492f46Bc8676c3A48EaBff4e',
      '0xC524e925bdad2419aD31d180300582F7025873dF',
      '0x037fC21641B60e747b46E72F55e1B1337aEB2776'
    ],
    10006794: [
      // Juan Soto
      '0x8ae25fB4fa812395B6d4dD4a4C7ac10D627Ac1fE',
      '0x7057BE5B6E897E910D30178630529643469D9BfB',
      '0xcE44443d4F652fC6c48f62258c75278E11909d6a'
    ],
    10000908: [
      // Marcus Semien
      '0xc98E1EC69D9413c0D74FE6723Dc7D05e3F95dBd0',
      '0xDf40952AAA578272061BD40bEcC125a5a510a62F',
      '0x0860e4C9728E6658F36B314Cdb996CdbD561f8E0'
    ],
    10001009: [
      // Starling Marte
      '0x01c86DeADD7f6993b92D746A53Bab5c8Dd2A97bA',
      '0xa33acF2F8e7CF4e522d0958380d1BC00E42199DB',
      '0xAD9f9A1EBF43725aBEAcb8B9777CBebE42a5693d'
    ],
    10002094: [
      // Trea Turner
      '0x5bB30505Fa69487eC79501a58bb73dEA4D402b80',
      '0x8c5297bC8dFc42Fe4dC5Dd84f3fa8E1dE74D6f66',
      '0x09602a00D9E7a6C93544d74B006739B6D0CF4c1D'
    ],
    10007501: [
      // Vladimir Guerrero Jr.
      '0xbe065AD544D911b101c7393f4e99b43418535daD',
      '0xE91c7952Be8AcbfE6088aAfC50516496273A8aDA',
      '0x37d388321c2cE1E130e36443e8dAE91836a786C0'
    ],
    20737: [
      // Josh Allen
      '0x9a9f951a7421a50a119DD2c642E66e5ccc5ff49F',
      '0x6Ac79d38d52228315016F3DFdaF63a22AbD87277',
      '0xc8e60382a4446833afDd515f70C5F3bD05D5CbE7'
    ],
    18890: [
      // Patrick Mahomes
      '0x4167F2954B44C97DD13a3e9f81D1D42c103B04cb',
      '0x16A33CB973cAB6C2c49e2741d874DeE467a4A4Cb',
      '0x23533Eef4771CCEdBB3b718b9933c93601b28a5d'
    ],
    22049: [
      // Lamar Jackson
      '0x4790944f6706AB2c6db59dfB8A5eFC050B6Ca0B0',
      '0x4f82912BEC1d7422052af7fb0f20eA562440A3a4',
      '0x0B921Ff8bF63dd911f2A886F0E76ce8dc1F33354'
    ],
    17959: [
      // Derrick Henry
      '0x394c7cE48208099e7530cF0cCb5374Cc1C1B35f8',
      '0x0a4152837412C32A7DeA95c71e3cE2d89E0570A2',
      '0x28A01e0675069418d72498466C0F53681097DA1d'
    ],
    21837: [
      // Jonathan Taylor
      '0x466F23e712a7F9729E3b8C0E4A1a47623B62f7D0',
      '0xf3393C45bF037eaaAbb5d23987E6Af3a3e2aA20C',
      '0x61700f263aEC72aA6Cda1af8623602e3a287BedB'
    ],
    18877: [
      // Christian McCaffrey
      '0x8e32E85F34c7Ca7Ad38890aeF85d448560Cf3347',
      '0x3025693B300e505fBEF750fecD090Bc4Ca1F5c9D',
      '0xD6Aa3270e2EDdFe5F80218D2198169D468696bA1'
    ],
    19562: [
      // Austin Ekeler
      '0x4f4e7E6700f9D2f3a2B6a5C05F8cdA37ce9AD479',
      '0xc4255833AEb5F72e8B66A08aCBE6Cd829474982F',
      '0x562BB9409455e1653f432d0ec2B56963aCDEEfb8'
    ],
    18882: [
      // Cooper Kupp
      '0x8B7accbaEE3137B1e8f3562e71916C2d73101D56',
      '0x2f233B0Ac71eC421803D7D7cE87ED79d0b2737F7',
      '0xcB86cB959d5dbdC086f912Fd43b057805CD29Ed5'
    ],
    22555: [
      // Justin Jefferson
      '0xaae20D4f7937419D3edd2239A2E9adD30A762c46',
      '0xddd235Bf25e0FAD473b11D1925d4366a914C81C2',
      '0xBA37251bd52987e9285803cA7743741fAe7fC192'
    ],
    22564: [
      // Ja'Marr Chase
      '0xD997d403687A0978DE2CB633007A43a18006f680',
      '0x720aDf254B41A64B8047de560d8f580C0B1d1400',
      '0xe839527cF8C6Bbd42F122F3ff958086d34866fB4'
    ],
    15048: [
      // Travis Kelce
      '0x07f23c0716C0A6254d2d1910932773c3AE1DE9E4',
      '0xfb9B87032aEa622318b2fCBaFEA284F5BeED3afE',
      '0x617dfC11f7A16048346244635255c1cE7DAC45A9'
    ],
    19803: [
      // Mark Andrews
      '0x2B1B785aD6CC182Ed739e6585812c46591eB8338',
      '0x6bd5144302f8d9Ff0170755f0310432c2258E642',
      '0x8a2A9FbcF2Ab1cB2aC0D1feab55a46294ce05352'
    ],
    22508: [
      // Kyle Pitts
      '0xDC354d61EC8fde94B549c5d8560C4136A0537601',
      '0x6100143a4C5285e123bb5c9fBECfbE8c25d00BC7',
      '0x48cb73C1a4B4eCfFFf4cE7Ab8bc0547a3E9F26ab'
    ],
    19063: [
      // Geroge Kittle
      '0xC24a3D5dd6ac8E121b2A877785ecad28E586785A',
      '0x3bC7e306fd60f58171C4a44d37cdb55BF46C5288',
      '0xA110462D09bf539d864BEEACa4B444981A7D5BD5'
    ],
    21681: [
      // Justin Herbert
      '0xB427A0443ec6cdB7BcB081870cc98890Fd70f689',
      '0x32D9a55743102f3F289DECbcC3b84f8F47DB3155',
      '0x11003F7b5f0Dd74E3b81c46a209b0B91C0e865A0'
    ],
  };

  static const List<List<dynamic>> namesList = [
    ['Aaron Judge', 10002087, 'AJLT1010', 'AJST1010', SupportedSport.MLB],
    ['Bryce Harper', 10001365, 'BHLT1010', 'BHST1010', SupportedSport.MLB],
    ['Carlos Correa', 10001918, 'CCLT1010', 'CCST1010', SupportedSport.MLB],
    [
      'Fernando Tatis Jr.',
      10007217,
      'FTJLT1010',
      'FTJST1010',
      SupportedSport.MLB
    ],
    ['Jose Ramirez', 10000352, 'JRLT1010', 'JRST1010', SupportedSport.MLB],
    ['Juan Soto', 10006794, 'JSLT1010', 'JSST1010', SupportedSport.MLB],
    ['Marcus Semien', 10000908, 'MSLT1010', 'MSST1010', SupportedSport.MLB],
    ['Starling Marte', 10001009, 'SMLT1010', 'SMST1010', SupportedSport.MLB],
    ['Trea Turner', 10002094, 'TTLT1010', 'TTST1010', SupportedSport.MLB],
    [
      'Vladimir Guerrero Jr.',
      10007501,
      'VGJLT1010',
      'VGJST1010',
      SupportedSport.MLB
    ],
    ['Josh Allen', 20737, 'JLLAPT', 'JLSAPT', SupportedSport.NFL],
    ['Justin Herbert', 21681, 'JHLAPT', 'JHSAPT', SupportedSport.NFL],
    ['Patrick Mahomes', 18890, 'PMLAPT', 'PMSAPT', SupportedSport.NFL],
    ['Lamar Jackson', 22049, 'LJLAPT', 'LJSAPT', SupportedSport.NFL],
    ['Johnathan Taylor', 21837, 'JTLAPT', 'JTSAPT', SupportedSport.NFL],
    ['Derrick Henry', 17959, 'DHLAPT', 'DHSAPT', SupportedSport.NFL],
    ['Christian McCaffrey', 18877, 'CMLAPT', 'CMSAPT', SupportedSport.NFL],
    ['Austin Ekeler', 19562, 'AELAPT', 'AESAPT', SupportedSport.NFL],
    ['Cooper Kupp', 18882, 'CKLAPT', 'CKSAPT', SupportedSport.NFL],
    ['Justin Jefferson', 22555, 'JJLAPT', 'JJSAPT', SupportedSport.NFL],
    ['JaMarr Chase', 22564, 'JCLAPT', 'JCSAPT', SupportedSport.NFL],
    ['Travis Kelce', 15048, 'TKLAPT', 'TKSAPT', SupportedSport.NFL],
    ['Mark Andrews', 19803, 'MALAPT', 'MASAPT', SupportedSport.NFL],
    ['Kyle Pitts', 22508, 'KPLAPT', 'KPSAPT', SupportedSport.NFL],
    ['George Kittle', 19063, 'GKLAPT', 'GKSAPT', SupportedSport.NFL],
  ];

  static final List<Token> tokenList = [
    AXT(
      'AthleteX',
      'AX',
      const AssetImage('assets/images/X_Logo_Black_BR.png'),
    ),
    SXT('SportX', 'SX', const AssetImage('assets/images/SX_Small.png')),
    MATIC(
      'Matic/Polygon',
      'Matic',
      const AssetImage('assets/images/Polygon_Small.png'),
    ),
    WETH('WETH', 'WETH', const AssetImage('assets/images/weth_small.png')),
    USDC('USDC', 'USDC', const AssetImage('assets/images/USDC_small.png')),
    ...namesList.map((ath) {
      return APT(
        '${ath[0] as String} Long APT',
        ath[2] as String,
        const AssetImage('assets/images/apt_noninverted.png'),
        idToAddress[ath[1]]![1],
        ath[4] as SupportedSport,
      );
    }),
    ...namesList.map((ath) {
      return APT(
        '${ath[0] as String} Short APT',
        ath[3] as String,
        const AssetImage('assets/images/apt_inverted.png'),
        idToAddress[ath[1]]![2],
        ath[4] as SupportedSport,
      );
    }),
  ];

  static String mapTickerToName(String ticker) {
    final name =
        tokenList.firstWhereOrNull((token) => token.ticker == ticker)?.name ??
            '';
    return name;
  }

  static SupportedSport mapTickerToSport(String ticker) {
    final sport =
        tokenList.firstWhereOrNull((token) => token.ticker == ticker)?.sport ??
            SupportedSport.all;
    return sport;
  }
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
  final longTokenIndex =
      TokenList.namesList.indexWhere((element) => element.contains(id));
  return longTokenIndex >= 0
      ? TokenList.namesList[longTokenIndex][2] as String
      : '';
}

String getShortAthleteSymbol(int id) {
  final shortTokenIndex =
      TokenList.namesList.indexWhere((element) => element.contains(id));
  return shortTokenIndex >= 0
      ? TokenList.namesList[shortTokenIndex][3] as String
      : '';
}
