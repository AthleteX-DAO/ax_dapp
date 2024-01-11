import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/config/models/event_config.dart';
import 'package:ethereum_api/src/ethereum/models/empty_address.dart';

const basketballEvents = [
  EventConfig.empty,
  EventConfig(
    eventId: 001,
    eventName:
        'Will Jayson Tatum Score more than 20 points in the December 1st 76ers vs Celtics Basketball Game? If Tatum scores more than 20 points, the market will resolve to YES.  If Tatum scores less than 20 points, the market will resolve to NO.  If the game is not completed by December 1st, 2023 (11:59:59 PM ET), the market will resolve to 50-50.',
    eventTicker: 'JT-CELTICS-12-1-23',
    eventMarketAddressConfig: EthereumAddressConfig.event(
      polygonMainnet: '0x4de21dc72ee1e2608ae68019fc0541937291ed21',
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kEmptyAddress,
      arbitriumOne: kEmptyAddress,
    ),
    longAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x711b8208753fC1B9ed2836519c02Da649157E864',
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kNullAddress,
      arbitriumOne: kNullAddress,
    ),
    shortAddressConfig: EthereumAddressConfig.apt(
      polygonMainnet: '0x7207955D582B737f4553a8485A69E39E2A553Db0',
      goerliTestNet: kNullAddress,
      sportxMainnet: kNullAddress,
      sportxTestnet: kNullAddress,
      optimism: kNullAddress,
      arbitriumOne: kNullAddress,
    ),
  ),
];
