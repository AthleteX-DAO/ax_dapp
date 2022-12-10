import 'package:ethereum_api/src/apt_router/apt_router.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';

/// {@template ethereum_address_config}
/// Configures an object with addresses, one for each supported [EthereumChain].
/// {@endtemplate}
class EthereumAddressConfig {
  /// Configuration for [Token.ax].
  const EthereumAddressConfig.axt()
      : polygonMainnet = '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
        goerliTestNet = '0x06c3B420C054d2170dca99Ca3e455E4C654A0c2f',
        sportxMainnet = '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.sx].
  const EthereumAddressConfig.sxt()
      : polygonMainnet = '0x840195888db4d6a99ed9f73fcd3b225bb3cb1a79',
        goerliTestNet = '0x79ECd185478882c1075f9972587D6c1d59d1A44f',
        sportxMainnet = '0xaa99be3356a11ee92c3f099bd7a038399633566f',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.wsx].
  const EthereumAddressConfig.wsxt()
      : polygonMainnet = kEmptyAddress,
        goerliTestNet = '0x79ECd185478882c1075f9972587D6c1d59d1A44f',
        sportxMainnet = '0xaa99be3356a11ee92c3f099bd7a038399633566f',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.matic].
  const EthereumAddressConfig.matic()
      : polygonMainnet = '0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270',
        goerliTestNet = '0x499d11e0b6eac7c0593d8fb292dcbbf815fb29ae',
        sportxMainnet = '0xfa6f64dfbad14e6883321c2f756f5b22ff658f9c',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.weth].
  const EthereumAddressConfig.weth()
      : polygonMainnet = '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619',
        goerliTestNet = '0x47a4357315e1d3AB3294c161c3a52e8b0d3A4109',
        sportxMainnet = '0xa173954cc4b1810c0dbdb007522adbc182dab380',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.usdc].
  const EthereumAddressConfig.usdc()
      : polygonMainnet = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
        goerliTestNet = '0x3a034FE373B6304f98b7A24A3F21C958946d4075',
        sportxMainnet = '0xe2aa35c2039bd0ff196a6ef99523cc0d3972ae3e',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Token.longApt] and [Token.shortApt].
  const EthereumAddressConfig.apt({
    required this.polygonMainnet,
    required this.goerliTestNet,
    required this.sportxMainnet,
    required this.sportxTestnet,
  });

  /// Configuration for [APTRouter] client.
  const EthereumAddressConfig.dexRouterAddress()
      : polygonMainnet = '0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95',
        goerliTestNet = '0x003bA57020B97b282160e13A6D502aF9A5BA8ABd',
        sportxMainnet = '0x4C2295082FC932EDE19EefB1af03c0b6B323610A',
        sportxTestnet = kEmptyAddress;

  /// Configuration for [Dex] client.
  const EthereumAddressConfig.dexFactoryAddress()
      : polygonMainnet = '0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B',
        goerliTestNet = '0x8b4AA21Efb25Bea2Bd90f4b6030c0E5646e63E67', 
        sportxMainnet = '0x668880Eb73AAd6474b8aE1C08D3310e765803717',
        sportxTestnet = kEmptyAddress;

  /// Configuration for farm owner.
  const EthereumAddressConfig.farmOwner()
      : polygonMainnet = '0xe1bf752fd7480992345629bf3866f6618d57a7da',
        goerliTestNet = kEmptyAddress,
        sportxMainnet = kEmptyAddress,
        sportxTestnet = kEmptyAddress;

  /// Configuration for pool info.
  const EthereumAddressConfig.poolInfo()
      : polygonMainnet = '0x53590f017d73bAb31A6CbCBF6500A66D92fecFbE',
        goerliTestNet = kEmptyAddress,
        sportxMainnet = kEmptyAddress,
        sportxTestnet = kEmptyAddress;

  /// Empty configuration.
  const EthereumAddressConfig.empty()
      : polygonMainnet = kEmptyAddress,
        goerliTestNet = kEmptyAddress,
        sportxMainnet = kEmptyAddress,
        sportxTestnet = kEmptyAddress;

  /// Represents the object address on the [EthereumChain.polygonMainnet].
  final String polygonMainnet;

  /// Represents the object address on the [EthereumChain.goerliTestNet].
  final String goerliTestNet;

  /// Represents the object address on the [EthereumChain.sxMainnet].
  final String sportxMainnet;

  /// Represents the object address on the [EthereumChain.sxTestnet].
  final String sportxTestnet;
}

/// [EthereumAddressConfig] extensions.
extension EthereumAddressConfigX on EthereumAddressConfig {
  /// Returns the correspondent object's address based on the current
  /// [EthereumChain]. For [EthereumChain.none] and [EthereumChain.unsupported]
  /// it will return [kEmptyAddress].
  String address(EthereumChain chain) {
    switch (chain) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        return kEmptyAddress;
      case EthereumChain.polygonMainnet:
        return polygonMainnet;
      case EthereumChain.goerliTestNet:
        return goerliTestNet;
      case EthereumChain.sxMainnet:
        return sportxMainnet;
      case EthereumChain.sxTestnet:
        return sportxTestnet;
    }
  }
}
