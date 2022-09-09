import 'package:ethereum_api/src/apt_router/apt_router.dart';
import 'package:ethereum_api/src/config/models/apt_config.dart';
import 'package:ethereum_api/src/config/models/apts/mlb_apt_list.dart';
import 'package:ethereum_api/src/config/models/apts/nfl_apt_list.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/config/models/ethereum_url_config.dart';
import 'package:ethereum_api/src/apt_factory/apt_factory.dart';
import 'package:ethereum_api/src/pool_info/pool_info.dart';
import 'package:ethereum_api/src/tokens/tokens.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

// TODO(Pearlson): confirm info
/// {@template ethereum_chain}
/// Represents an `Ethereum` blockchain network.
/// {@endtemplate}
enum EthereumChain {
  /// Represents no network.
  none(
    chainId: 0,
    chainName: '__none__',
    currency: EthereumCurrency.none,
    rpcUrls: [],
    blockExplorerUrls: [],
  ),

  /// Represents an unsupported network.
  unsupported(
    chainId: -1,
    chainName: '__unsupported__',
    currency: EthereumCurrency.none,
    rpcUrls: [],
    blockExplorerUrls: [],
  ),

  /// Polygon main network.
  polygonMainnet(
    chainId: 137,
    chainName: 'Polygon',
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
    chainName: 'SX Network',
    currency: EthereumCurrency.sx,
    rpcUrls: ['https://api-stage.athletex.io/sx/rpc'],
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

  /// Factory constructor that allows creating an `EthereumChain` from a given
  /// [chainId]. If the [chainId] is not supported then it will return an
  /// [EthereumChain.unsupported].
  factory EthereumChain.fromChainId(int chainId) =>
      EthereumChain.values.firstWhere(
        (chain) => chain.chainId == chainId,
        orElse: () => EthereumChain.unsupported,
      );

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

  /// Returns a list of supported [EthereumChain]s.
  static List<EthereumChain> get supportedValues =>
      values.where((chain) => chain.chainId != 647 && chain.isSupported).toList();
}

/// [EthereumChain] extensions.
extension ChainX on EthereumChain {
  /// Returns whether this [EthereumChain] is supported.
  bool get isSupported =>
      this != EthereumChain.none && this != EthereumChain.unsupported;

  /// Returns the RPC URL used to initialize a [Web3Client].
  String get rpcUrl => rpcUrls.firstOrNull ?? '';

  /// Gets the associated address of the farm owner for this [EthereumChain].
  String getFarmOwner() =>
      const EthereumAddressConfig.farmOwner().address(this);

  /// Creates a [PoolInfo] client based on this [EthereumChain] configuration.
  PoolInfo createPoolInfo(Web3Client client) => PoolInfo(
        address: EthereumAddress.fromHex(
          const EthereumAddressConfig.poolInfo().address(this),
        ),
        client: client,
      );
}

/// [EthereumChain] configuration.
extension ChainConfigX on EthereumChain {
  /// Generates a list of all available [Token]s for this [EthereumChain].
  List<Token> createTokens() => [
        Token.ax(this),
        Token.sx(this),
        Token.matic(this),
        Token.weth(this),
        Token.usdc(this),
        ...createApts(this),
      ];

  /// Generates the list of [Apt]'s for this [EthereumChain]. Composed based on
  /// a list of [AptConfig]s.
  List<Token> createApts(EthereumChain chain) {
    debugPrint(
      'Creating apts for Chain Name: ${chain.chainName}; ChainId: ${chain.chainId} Name: ${chain.name}',
    );
    final supportedApts =
        ((chain.chainId == EthereumChain.polygonMainnet.chainId) ||
                (chain.chainId == EthereumChain.polygonTestnet.chainId))
            ? mlbApts
            : nflApts;
    return supportedApts
        .expand(
          (aptConfig) => [
            Token.longApt(this, aptConfig: aptConfig),
            Token.shortApt(this, aptConfig: aptConfig),
          ],
        )
        .toList();
  }

  /// Creates a [Web3Client] based on this [EthereumChain] configuration.
  Web3Client createWeb3Client(http.Client httpClient) =>
      Web3Client(rpcUrl, httpClient);

  /// Creates an [APTRouter] client based on this [EthereumChain] configuration.
  APTRouter createAptRouterClient(Web3Client client) => APTRouter(
        address: EthereumAddress.fromHex(
          const EthereumAddressConfig.dexRouterAddress().address(this),
        ),
        client: client,
      );

  /// Creates a [Dex] client based on this [EthereumChain] configuration.
  APTFactory createAptFactoryClient(Web3Client client) => APTFactory(
        address: EthereumAddress.fromHex(
          const EthereumAddressConfig.dexFactoryAddress().address(this),
        ),
        client: client,
      );

  /// Creates a dex [GraphQLClient] based on this [EthereumChain] configuration.
  GraphQLClient createDexGraphQLClient() {
    final policy = Policies(
      cacheReread: CacheRereadPolicy.ignoreAll,
      fetch: FetchPolicy.networkOnly,
      error: ErrorPolicy.ignore,
    );
    return GraphQLClient(
      link: HttpLink(const EthereumUrlConfig.dex().url(this)),
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(
        query: policy,
        watchMutation: policy,
        watchQuery: policy,
        mutate: policy,
        subscribe: policy,
      ),
    );
  }

  /// Creates a gysr [GraphQLClient] based on this [EthereumChain]
  /// configuration.
  GraphQLClient createGysrGraphQLClient() {
    final policy = Policies(fetch: FetchPolicy.networkOnly);
    return GraphQLClient(
      link: HttpLink(const EthereumUrlConfig.gysr().url(this)),
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(
        watchQuery: policy,
        query: policy,
        mutate: policy,
      ),
    );
  }
}
