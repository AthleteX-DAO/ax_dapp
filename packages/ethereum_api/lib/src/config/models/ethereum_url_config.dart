import 'package:ethereum_api/src/ethereum/models/models.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';

/// {@template ethereum_url_config}
/// Configures an object with URLs, one for each supported [EthereumChain].
/// {@endtemplate}
class EthereumUrlConfig {
  /// Configuration for GraphQL dex link.
  const EthereumUrlConfig.dex()
      : polygonMainnet =
            'https://api.thegraph.com/subgraphs/name/nyamwaya/athletex-dex-subgraph-mainnet',
        polygonTestnet = kEmptyUrl,
        sxMainnet =
            'https://graph.sx.technology/subgraphs/name/sportstoken/athletex-dex',
        sxTestnet = kEmptyUrl;

  /// Configuration for GraphQL gysr link.
  const EthereumUrlConfig.gysr()
      : polygonMainnet =
            'https://api.thegraph.com/subgraphs/name/gysr-io/gysr-polygon',
        polygonTestnet = kEmptyUrl,
        sxMainnet = kEmptyUrl,
        sxTestnet = kEmptyUrl;

  /// Empty configuration.
  const EthereumUrlConfig.empty()
      : polygonMainnet = kEmptyUrl,
        polygonTestnet = kEmptyUrl,
        sxMainnet = kEmptyUrl,
        sxTestnet = kEmptyUrl;

  /// Represents the object URL on the [EthereumChain.polygonMainnet].
  final String polygonMainnet;

  /// Represents the object URL on the [EthereumChain.polygonTestnet].
  final String polygonTestnet;

  /// Represents the object URL on the [EthereumChain.sxMainnet].
  final String sxMainnet;

  /// Represents the object URL on the [EthereumChain.sxTestnet].
  final String sxTestnet;
}

/// [EthereumUrlConfig] extensions.
extension EthereumUrlConfigX on EthereumUrlConfig {
  /// Returns the correspondent object's URL based on the current
  /// [EthereumChain]. For [EthereumChain.none] and [EthereumChain.unsupported]
  /// it will return [kEmptyUrl].
  String url(EthereumChain chain) {
    switch (chain) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        return kEmptyUrl;
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
