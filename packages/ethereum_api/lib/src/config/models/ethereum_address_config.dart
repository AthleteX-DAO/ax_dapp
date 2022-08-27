import 'package:ethereum_api/src/apt_router/apt_router.dart';
import 'package:ethereum_api/src/dex/dex.dart';
import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';

/// {@template ethereum_address_config}
/// Configures an object with addresses, one for each supported [EthereumChain].
/// {@endtemplate}
class EthereumAddressConfig {
  /// Configuration for [Token.ax].
  const EthereumAddressConfig.axt()
      : polygonMainnet = '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
        polygonTestnet = '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Token.sx].
  const EthereumAddressConfig.sxt()
      : polygonMainnet = '0x840195888db4d6a99ed9f73fcd3b225bb3cb1a79',
        polygonTestnet = '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Token.matic].
  const EthereumAddressConfig.matic()
      : polygonMainnet = '0x0000000000000000000000000000000000001010',
        polygonTestnet = '0x0000000000000000000000000000000000001010',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Token.weth].
  const EthereumAddressConfig.weth()
      : polygonMainnet = '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Token.usdc].
  const EthereumAddressConfig.usdc()
      : polygonMainnet = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Token.longAp] and [Token.shortAp].
  const EthereumAddressConfig.apt({
    required this.polygonMainnet,
    required this.polygonTestnet,
    required this.sxMainnet,
    required this.sxTestnet,
  });

  /// Configuration for [APTRouter] client.
  const EthereumAddressConfig.aptRouter()
      : polygonMainnet = '0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95',
        polygonTestnet = '0x7EFc361e568d0038cfB200dF9d9Be27943e19017',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for [Dex] client.
  const EthereumAddressConfig.dex()
      : polygonMainnet = '0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B',
        polygonTestnet = '0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for farm owner.
  const EthereumAddressConfig.farmOwner()
      : polygonMainnet = '0xe1bf752fd7480992345629bf3866f6618d57a7da',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for pool info.
  const EthereumAddressConfig.poolInfo()
      : polygonMainnet = '0x53590f017d73bAb31A6CbCBF6500A66D92fecFbE',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Empty configuration.
  const EthereumAddressConfig.empty()
      : polygonMainnet = kEmptyAddress,
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Represents the object address on the [EthereumChain.polygonMainnet].
  final String polygonMainnet;

  /// Represents the object address on the [EthereumChain.polygonTestnet].
  final String polygonTestnet;

  /// Represents the object address on the [EthereumChain.sxMainnet].
  final String sxMainnet;

  /// Represents the object address on the [EthereumChain.sxTestnet].
  final String sxTestnet;
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
      case EthereumChain.polygonTestnet:
        return polygonTestnet;
      case EthereumChain.sxMainnet:
        return sxMainnet;
      case EthereumChain.sxTestnet:
        return sxTestnet;
    }
  }
}