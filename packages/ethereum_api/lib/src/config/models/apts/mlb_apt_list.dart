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
      polygonMainnet: 'TODO',
      goerliTestNet: 'TODO',
      sportxMainnet: 'TODO',
      sportxTestnet: 'TODO',
      optimism: '',
      arbitriumOne: '',
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      goerliTestNet: 'TODO',
      sportxMainnet: 'TODO',
      sportxTestnet: 'TODO',
      optimism: '',
      arbitriumOne: '',
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: 'TODO',
      goerliTestNet: 'TODO',
      sportxMainnet: 'TODO',
      sportxTestnet: 'TODO',
      optimism: '',
      arbitriumOne: '',
    ),
  ),
];
