/// {@template ethereum_chain}
/// Represents an `Ethereum` blockchain network.
/// {@endtemplate}
enum EthereumChain {
  /// Polygon main network.
  polygonMainnet(137),

  /// Polygon test network.
  polygonTestnet(80001),

  /// SX main network.
  sxMainnet(416),

  /// SX test network.
  sxTestnet(647);

  /// {@macro ethereum_chain}
  const EthereumChain(this.chainId);

  /// Uniquely identifies an `Ethereum` network.
  final int chainId;
}
