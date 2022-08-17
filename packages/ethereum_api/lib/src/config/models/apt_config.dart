import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:shared/shared.dart';

/// {@template athlete_performance_token_config}
/// Configures an [Apt].
/// {@endtemplate}
class AptConfig extends Equatable {
  /// {@macro athlete_performance_token_config}
  const AptConfig({
    required this.athleteId,
    required this.athleteName,
    required this.longTicker,
    required this.shortTicker,
    required this.pairAddressConfig,
    required this.longAddressConfig,
    required this.shortAddressConfig,
    required this.sport,
  });

  /// {@template athlete_id}
  /// Represents athelete's ID.
  /// {@endtemplate}
  final int athleteId;

  /// {@template athlete_name}
  /// Represents athlete's name.
  /// {@endtemplate}
  final String athleteName;

  /// Represents [Apt.long]'s ticker.
  final String longTicker;

  /// Represents [Apt.short]'s ticker.
  final String shortTicker;

  /// Represents [Apt]'s pair address configuration.
  final EthereumAddressConfig pairAddressConfig;

  /// Represents [Apt.long]'s address configuration.
  final EthereumAddressConfig longAddressConfig;

  /// Represents [Apt.short]'s address configuration.
  final EthereumAddressConfig shortAddressConfig;

  /// Represents athlete's [SupportedSport].
  final SupportedSport sport;

  @override
  List<Object?> get props => [
        athleteId,
        athleteName,
        longTicker,
        shortTicker,
        pairAddressConfig,
        longAddressConfig,
        shortAddressConfig,
        sport,
      ];

  /// Represents an empty [AptConfig]. Useful as default value.
  static const empty = AptConfig(
    athleteId: 0,
    athleteName: '',
    longTicker: '',
    shortTicker: '',
    pairAddressConfig: EthereumAddressConfig.empty(),
    longAddressConfig: EthereumAddressConfig.empty(),
    shortAddressConfig: EthereumAddressConfig.empty(),
    sport: SupportedSport.all,
  );

  /// Static list of [AptConfig]s used to generate [Token.shortAp]s and
  /// [Token.longAp]s.
  static const List<AptConfig> values = _kAptConfigs;
}

/// [AptConfig] extensions.
extension AptConfigX on AptConfig {
  /// Returns [Apt]'s name based on [AptType], e.g.: `Aaron Judge Long APT`.
  String aptName(AptType aptType) =>
      '$athleteName ${aptType.name.capitalize()} APT';
}

const _kAptConfigs = [
  AptConfig(
    athleteId: 10002087,
    athleteName: 'Aaron Judge',
    sport: SupportedSport.MLB,
    longTicker: 'AJLT1010',
    shortTicker: 'AJST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x19d5b8f926596a31CA1c25cEf8C79A267EDC9864',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x481Bf3dbdE952CE684Dc500Fd9EdEF88f6607A8C',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xA16dd54C674AE300d6DF436E536584eb3AB2F081',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10001365,
    athleteName: 'Bryce Harper',
    sport: SupportedSport.MLB,
    longTicker: 'BHLT1010',
    shortTicker: 'BHLT1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xD1f6F00a83b1938D697c730dDcad4410F00787De',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x9fd9b5164EAe6E78887beAE74Cbed54D853A6b33',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xBc9095AFF510544846E34926757aCAFd471e0b33',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10001918,
    athleteName: 'Carlos Correa',
    sport: SupportedSport.MLB,
    longTicker: 'CCLT1010',
    shortTicker: 'CCST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x53eCe60F883a8C7E16Bb3294808bA589Ab210a6E',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x056A9154d86a994A840935ba995F701370B070F3',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x9229d63a787ab7005E43b716e39096be90F4A77E',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10007217,
    athleteName: 'Fernando Tatis Jr.',
    sport: SupportedSport.MLB,
    longTicker: 'FTJLT1010',
    shortTicker: 'FTJST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x251C607fF5680d5c98761E34464E8Dfe849Ce842',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xFbD2CF33E9aE10bE77AF3A4c3Cac04B4314ceBAc',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x5Ce78a5bA2956895583C4EDf40053E17b2b5744c',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10000352,
    athleteName: 'Jose Ramirez',
    sport: SupportedSport.MLB,
    longTicker: 'JRLT1010',
    shortTicker: 'JRST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x34Ca688D00CaAF3a492f46Bc8676c3A48EaBff4e',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xC524e925bdad2419aD31d180300582F7025873dF',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x037fC21641B60e747b46E72F55e1B1337aEB2776',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10006794,
    athleteName: 'Juan Soto',
    sport: SupportedSport.MLB,
    longTicker: 'JSLT1010',
    shortTicker: 'JSST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x8ae25fB4fa812395B6d4dD4a4C7ac10D627Ac1fE',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x7057BE5B6E897E910D30178630529643469D9BfB',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xcE44443d4F652fC6c48f62258c75278E11909d6a',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10000908,
    athleteName: 'Marcus Semien',
    sport: SupportedSport.MLB,
    longTicker: 'MSLT1010',
    shortTicker: 'MSST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xc98E1EC69D9413c0D74FE6723Dc7D05e3F95dBd0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xDf40952AAA578272061BD40bEcC125a5a510a62F',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x0860e4C9728E6658F36B314Cdb996CdbD561f8E0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10001009,
    athleteName: 'Starling Marte',
    sport: SupportedSport.MLB,
    longTicker: 'SMLT1010',
    shortTicker: 'SMST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x01c86DeADD7f6993b92D746A53Bab5c8Dd2A97bA',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xa33acF2F8e7CF4e522d0958380d1BC00E42199DB',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xAD9f9A1EBF43725aBEAcb8B9777CBebE42a5693d',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10002094,
    athleteName: 'Trea Turner',
    sport: SupportedSport.MLB,
    longTicker: 'TTLT1010',
    shortTicker: 'TTST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x5bB30505Fa69487eC79501a58bb73dEA4D402b80',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x8c5297bC8dFc42Fe4dC5Dd84f3fa8E1dE74D6f66',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x09602a00D9E7a6C93544d74B006739B6D0CF4c1D',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 10007501,
    athleteName: 'Vladimir Guerrero Jr.',
    sport: SupportedSport.MLB,
    longTicker: 'VGJLT1010',
    shortTicker: 'VGJST1010',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xbe065AD544D911b101c7393f4e99b43418535daD',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xE91c7952Be8AcbfE6088aAfC50516496273A8aDA',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x37d388321c2cE1E130e36443e8dAE91836a786C0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 20737,
    athleteName: 'Josh Allen',
    sport: SupportedSport.NFL,
    longTicker: 'JLLAPT',
    shortTicker: 'JLSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x9a9f951a7421a50a119DD2c642E66e5ccc5ff49F',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x6Ac79d38d52228315016F3DFdaF63a22AbD87277',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xc8e60382a4446833afDd515f70C5F3bD05D5CbE7',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18890,
    athleteName: 'Patrick Mahomes',
    sport: SupportedSport.NFL,
    longTicker: 'PMLAPT',
    shortTicker: 'PMSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x4167F2954B44C97DD13a3e9f81D1D42c103B04cb',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x16A33CB973cAB6C2c49e2741d874DeE467a4A4Cb',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x23533Eef4771CCEdBB3b718b9933c93601b28a5d',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22049,
    athleteName: 'Lamar Jackson',
    sport: SupportedSport.NFL,
    longTicker: 'LJLAPT',
    shortTicker: 'LJSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x4790944f6706AB2c6db59dfB8A5eFC050B6Ca0B0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x4f82912BEC1d7422052af7fb0f20eA562440A3a4',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x0B921Ff8bF63dd911f2A886F0E76ce8dc1F33354',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 17959,
    athleteName: 'Derrick Henry',
    sport: SupportedSport.NFL,
    longTicker: 'DHLAPT',
    shortTicker: 'DHSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x394c7cE48208099e7530cF0cCb5374Cc1C1B35f8',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x0a4152837412C32A7DeA95c71e3cE2d89E0570A2',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x28A01e0675069418d72498466C0F53681097DA1d',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 21837,
    athleteName: 'Jonathan Taylor',
    sport: SupportedSport.NFL,
    longTicker: 'JTLAPT',
    shortTicker: 'JTSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x466F23e712a7F9729E3b8C0E4A1a47623B62f7D0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xf3393C45bF037eaaAbb5d23987E6Af3a3e2aA20C',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x61700f263aEC72aA6Cda1af8623602e3a287BedB',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18877,
    athleteName: 'Christian McCaffrey',
    sport: SupportedSport.NFL,
    longTicker: 'CMLAPT',
    shortTicker: 'CMSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x8e32E85F34c7Ca7Ad38890aeF85d448560Cf3347',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x3025693B300e505fBEF750fecD090Bc4Ca1F5c9D',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xD6Aa3270e2EDdFe5F80218D2198169D468696bA1',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19562,
    athleteName: 'Austin Ekeler',
    sport: SupportedSport.NFL,
    longTicker: 'AELAPT',
    shortTicker: 'AESAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x4f4e7E6700f9D2f3a2B6a5C05F8cdA37ce9AD479',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xc4255833AEb5F72e8B66A08aCBE6Cd829474982F',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x562BB9409455e1653f432d0ec2B56963aCDEEfb8',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 18882,
    athleteName: 'Cooper Kupp',
    sport: SupportedSport.NFL,
    longTicker: 'CKLAPT',
    shortTicker: 'CKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x8B7accbaEE3137B1e8f3562e71916C2d73101D56',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x2f233B0Ac71eC421803D7D7cE87ED79d0b2737F7',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xcB86cB959d5dbdC086f912Fd43b057805CD29Ed5',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22555,
    athleteName: 'Justin Jefferson',
    sport: SupportedSport.NFL,
    longTicker: 'JJLAPT',
    shortTicker: 'JJSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xaae20D4f7937419D3edd2239A2E9adD30A762c46',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xddd235Bf25e0FAD473b11D1925d4366a914C81C2',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xBA37251bd52987e9285803cA7743741fAe7fC192',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22564,
    athleteName: "Ja'Marr Chase",
    sport: SupportedSport.NFL,
    longTicker: 'JCLAPT',
    shortTicker: 'JCSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xD997d403687A0978DE2CB633007A43a18006f680',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x720aDf254B41A64B8047de560d8f580C0B1d1400',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xe839527cF8C6Bbd42F122F3ff958086d34866fB4',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 15048,
    athleteName: 'Travis Kelce',
    sport: SupportedSport.NFL,
    longTicker: 'TKLAPT',
    shortTicker: 'TKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x07f23c0716C0A6254d2d1910932773c3AE1DE9E4',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xfb9B87032aEa622318b2fCBaFEA284F5BeED3afE',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x617dfC11f7A16048346244635255c1cE7DAC45A9',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19803,
    athleteName: 'Mark Andrews',
    sport: SupportedSport.NFL,
    longTicker: 'MALAPT',
    shortTicker: 'MASAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x2B1B785aD6CC182Ed739e6585812c46591eB8338',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x6bd5144302f8d9Ff0170755f0310432c2258E642',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x8a2A9FbcF2Ab1cB2aC0D1feab55a46294ce05352',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 22508,
    athleteName: 'Kyle Pitts',
    sport: SupportedSport.NFL,
    longTicker: 'KPLAPT',
    shortTicker: 'KPSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xDC354d61EC8fde94B549c5d8560C4136A0537601',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x6100143a4C5285e123bb5c9fBECfbE8c25d00BC7',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x48cb73C1a4B4eCfFFf4cE7Ab8bc0547a3E9F26ab',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 19063,
    athleteName: 'George Kittle',
    sport: SupportedSport.NFL,
    longTicker: 'GKLAPT',
    shortTicker: 'GKSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xC24a3D5dd6ac8E121b2A877785ecad28E586785A',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x3bC7e306fd60f58171C4a44d37cdb55BF46C5288',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xA110462D09bf539d864BEEACa4B444981A7D5BD5',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
  AptConfig(
    athleteId: 21681,
    athleteName: 'Justin Herbert',
    sport: SupportedSport.NFL,
    longTicker: 'JHLAPT',
    shortTicker: 'JHSAPT',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0xB427A0443ec6cdB7BcB081870cc98890Fd70f689',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x32D9a55743102f3F289DECbcC3b84f8F47DB3155',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x11003F7b5f0Dd74E3b81c46a209b0B91C0e865A0',
      polygonTestnet: 'TODO',
      sxMainnet: 'TODO',
      sxTestnet: 'TODO',
    ),
  ),
];
