part of 'token.dart';

/// {@template token_address_config}
/// Configures a [Token] with addresses, one for each supported [EthereumChain].
/// {@endtemplate}
class TokenAddressConfig {
  /// Configuration for `AXT`.
  const TokenAddressConfig.axt()
      : polygonMainnet = '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df',
        polygonTestnet = '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for `SXT`.
  const TokenAddressConfig.sxt()
      : polygonMainnet = '0x840195888db4d6a99ed9f73fcd3b225bb3cb1a79',
        polygonTestnet = '0x76d9a6e4cdefc840a47069b71824ad8ff4819e85',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for `Matic`.
  const TokenAddressConfig.matic()
      : polygonMainnet = '0x0000000000000000000000000000000000001010',
        polygonTestnet = '0x0000000000000000000000000000000000001010',
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for `WETH`.
  const TokenAddressConfig.weth()
      : polygonMainnet = '0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for `USDC`.
  const TokenAddressConfig.usdc()
      : polygonMainnet = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174',
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Configuration for `APT`.
  const TokenAddressConfig.apt({
    required this.polygonMainnet,
    required this.polygonTestnet,
    required this.sxMainnet,
    required this.sxTestnet,
  });

  /// Empty configuration.
  const TokenAddressConfig.empty()
      : polygonMainnet = kEmptyAddress,
        polygonTestnet = kEmptyAddress,
        sxMainnet = kEmptyAddress,
        sxTestnet = kEmptyAddress;

  /// Represents the token address on the [EthereumChain.polygonMainnet].
  final String polygonMainnet;

  /// Represents the token address on the [EthereumChain.polygonTestnet].
  final String polygonTestnet;

  /// Represents the token address on the [EthereumChain.sxMainnet].
  final String sxMainnet;

  /// Represents the token address on the [EthereumChain.sxTestnet].
  final String sxTestnet;
}

/// [TokenAddressConfig] extensions.
extension TokenAddressConfigX on TokenAddressConfig {
  /// Returns the correspondent [Token]'s address based on the current
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
