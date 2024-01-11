import 'package:ethereum_api/src/config/models/apt_config.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';

/// gets the list of [mlbApts] along with supported addresses
const mlbApts = [
  AptConfig(
    athleteId: 00000000,
    athleteName: 'Default Athlete',
    sport: SupportedSport.MLB,
    longTicker: 'DALT',
    shortTicker: 'DAST',
    pairAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: kNullAddress,
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kNullAddress,
      arbitriumOne: kNullAddress,
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: kNullAddress,
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kNullAddress,
      arbitriumOne: kNullAddress,
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: kNullAddress,
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kNullAddress,
      arbitriumOne: kNullAddress,
    ),
  ),
];
