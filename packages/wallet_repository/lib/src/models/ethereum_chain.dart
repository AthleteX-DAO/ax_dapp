import 'package:wallet_repository/src/models/ethereum_currency.dart';

// TODO(Pearlson): confirm info
/// {@template ethereum_chain}
/// Represents an `Ethereum` blockchain network.
/// {@endtemplate}
enum EthereumChain {
  /// Polygon main network.
  polygonMainnet(
    chainId: 137,
    chainName: 'Polygon Mainnet',
    currency: EthereumCurrency.matic,
    rpcUrls: ['https://rpc-mainnet.matic.quiknode.pro'],
    blockExplorerUrls: ['https://polygonscan.com/'],
  ),

  /// Polygon test network.
  polygonTestnet(
    chainId: 80001,
    chainName: 'Polygon Testnet',
    currency: EthereumCurrency.matic,
    rpcUrls: ['https://matic-mumbai.chainstacklabs.com/'],
    blockExplorerUrls: ['https://polygonscan.com/'],
  ),

  /// SX main network.
  sxMainnet(
    chainId: 416,
    chainName: 'SX Mainnet',
    currency: EthereumCurrency.sx,
    rpcUrls: ['https://rpc.sx.technology'],
    blockExplorerUrls: ['https://explorer.sx.technology/'],
  ),

  /// SX test network.
  sxTestnet(
    chainId: 647,
    chainName: 'SX Testnet',
    currency: EthereumCurrency.sx,
    rpcUrls: ['https://rpc.toronto.sx.technology'],
    blockExplorerUrls: ['https://explorer.toronto.sx.technology/'],
  );

  /// {@macro ethereum_chain}
  const EthereumChain({
    required this.chainId,
    required this.chainName,
    required this.currency,
    required this.rpcUrls,
    this.blockExplorerUrls,
  });

  /// Uniquely identifies an `Ethereum` chain.
  final int chainId;

  /// The chain's name.
  final String chainName;

  /// Holds data about the native currency.
  final EthereumCurrency currency;

  /// List of RPC urls used by this [chainId].
  final List<String> rpcUrls;

  /// List of block explorer urls used by this [chainId].
  final List<String>? blockExplorerUrls;
}
