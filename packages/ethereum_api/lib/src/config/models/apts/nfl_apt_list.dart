import 'package:ethereum_api/src/config/models/apt_config.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';

/// gets the list of [nflApts] along with supported addresses
const nflApts = [
  AptConfig(
    athleteId: 19801,
    athleteName: 'Josh Allen',
    sport: SupportedSport.NFL,
    longTicker: 'JLLAPT',
    shortTicker: 'JLSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x9a9f951a7421a50a119DD2c642E66e5ccc5ff49F',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x6Ac79d38d52228315016F3DFdaF63a22AbD87277',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xc8e60382a4446833afDd515f70C5F3bD05D5CbE7',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18890,
    athleteName: 'Patrick Mahomes',
    sport: SupportedSport.NFL,
    longTicker: 'PMLAPT',
    shortTicker: 'PMSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x4167F2954B44C97DD13a3e9f81D1D42c103B04cb',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x16A33CB973cAB6C2c49e2741d874DeE467a4A4Cb',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x23533Eef4771CCEdBB3b718b9933c93601b28a5d',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22049,
    athleteName: 'Lamar Jackson',
    sport: SupportedSport.NFL,
    longTicker: 'LJLAPT',
    shortTicker: 'LJSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x4790944f6706AB2c6db59dfB8A5eFC050B6Ca0B0',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x4f82912BEC1d7422052af7fb0f20eA562440A3a4',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x0B921Ff8bF63dd911f2A886F0E76ce8dc1F33354',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 17959,
    athleteName: 'Derrick Henry',
    sport: SupportedSport.NFL,
    longTicker: 'DHLAPT',
    shortTicker: 'DHSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x394c7cE48208099e7530cF0cCb5374Cc1C1B35f8',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x0a4152837412C32A7DeA95c71e3cE2d89E0570A2',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x28A01e0675069418d72498466C0F53681097DA1d',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 21682,
    athleteName: 'Jonathan Taylor',
    sport: SupportedSport.NFL,
    longTicker: 'JTLAPT',
    shortTicker: 'JTSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x466F23e712a7F9729E3b8C0E4A1a47623B62f7D0',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xf3393C45bF037eaaAbb5d23987E6Af3a3e2aA20C',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x61700f263aEC72aA6Cda1af8623602e3a287BedB',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18877,
    athleteName: 'Christian McCaffrey',
    sport: SupportedSport.NFL,
    longTicker: 'CMLAPT',
    shortTicker: 'CMSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x8e32E85F34c7Ca7Ad38890aeF85d448560Cf3347',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x3025693B300e505fBEF750fecD090Bc4Ca1F5c9D',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xD6Aa3270e2EDdFe5F80218D2198169D468696bA1',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19562,
    athleteName: 'Austin Ekeler',
    sport: SupportedSport.NFL,
    longTicker: 'AELAPT',
    shortTicker: 'AESAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x4f4e7E6700f9D2f3a2B6a5C05F8cdA37ce9AD479',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xc4255833AEb5F72e8B66A08aCBE6Cd829474982F',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x562BB9409455e1653f432d0ec2B56963aCDEEfb8',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18882,
    athleteName: 'Cooper Kupp',
    sport: SupportedSport.NFL,
    longTicker: 'CKLAPT',
    shortTicker: 'CKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x8B7accbaEE3137B1e8f3562e71916C2d73101D56',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x2f233B0Ac71eC421803D7D7cE87ED79d0b2737F7',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xcB86cB959d5dbdC086f912Fd43b057805CD29Ed5',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 21685,
    athleteName: 'Justin Jefferson',
    sport: SupportedSport.NFL,
    longTicker: 'JJLAPT',
    shortTicker: 'JJSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xaae20D4f7937419D3edd2239A2E9adD30A762c46',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xddd235Bf25e0FAD473b11D1925d4366a914C81C2',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xBA37251bd52987e9285803cA7743741fAe7fC192',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22564,
    athleteName: "Ja'Marr Chase",
    sport: SupportedSport.NFL,
    longTicker: 'JCLAPT',
    shortTicker: 'JCSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xD997d403687A0978DE2CB633007A43a18006f680',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x720aDf254B41A64B8047de560d8f580C0B1d1400',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xe839527cF8C6Bbd42F122F3ff958086d34866fB4',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 15048,
    athleteName: 'Travis Kelce',
    sport: SupportedSport.NFL,
    longTicker: 'TKLAPT',
    shortTicker: 'TKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x07f23c0716C0A6254d2d1910932773c3AE1DE9E4',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xfb9B87032aEa622318b2fCBaFEA284F5BeED3afE',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x617dfC11f7A16048346244635255c1cE7DAC45A9',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19803,
    athleteName: 'Mark Andrews',
    sport: SupportedSport.NFL,
    longTicker: 'MALAPT',
    shortTicker: 'MASAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x2B1B785aD6CC182Ed739e6585812c46591eB8338',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x6bd5144302f8d9Ff0170755f0310432c2258E642',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x8a2A9FbcF2Ab1cB2aC0D1feab55a46294ce05352',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22508,
    athleteName: 'Kyle Pitts',
    sport: SupportedSport.NFL,
    longTicker: 'KPLAPT',
    shortTicker: 'KPSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xDC354d61EC8fde94B549c5d8560C4136A0537601',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x6100143a4C5285e123bb5c9fBECfbE8c25d00BC7',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x48cb73C1a4B4eCfFFf4cE7Ab8bc0547a3E9F26ab',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19063,
    athleteName: 'George Kittle',
    sport: SupportedSport.NFL,
    longTicker: 'GKLAPT',
    shortTicker: 'GKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xC24a3D5dd6ac8E121b2A877785ecad28E586785A',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x3bC7e306fd60f58171C4a44d37cdb55BF46C5288',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xA110462D09bf539d864BEEACa4B444981A7D5BD5',
      sportxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 21681,
    athleteName: 'Justin Herbert',
    sport: SupportedSport.NFL,
    longTicker: 'JHLAPT',
    shortTicker: 'JHSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0xB427A0443ec6cdB7BcB081870cc98890Fd70f689',
      sportxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x32D9a55743102f3F289DECbcC3b84f8F47DB3155',
      sportxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      polygonTestnet: 'TODO',
      sportxMainnet: '0x11003F7b5f0Dd74E3b81c46a209b0B91C0e865A0',
      sportxTestnet: 'TODO',
    ),
  ),
];
