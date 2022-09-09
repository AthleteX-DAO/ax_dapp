import 'package:ethereum_api/src/apt_router/apt_router.dart';
import 'package:ethereum_api/src/config/models/models.dart';
import 'package:ethereum_api/src/apt_factory/apt_factory.dart';
import 'package:ethereum_api/src/lsp/lsp.dart';
import 'package:ethereum_api/src/wallet/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

/// {@template config_api_client}
/// Client that manages `Ethereum` related configurations.
/// {@endtemplate}
class ConfigApiClient {
  /// {@macro config_api_client}
  ConfigApiClient({
    required EthereumChain defaultChain,
    required http.Client httpClient,
  })  : _httpClient = httpClient,
        _web3ClientController = BehaviorSubject<Web3Client>.seeded(
          defaultChain.createWeb3Client(httpClient),
        ),
        _dexGqlClientController = BehaviorSubject<GraphQLClient>.seeded(
          defaultChain.createDexGraphQLClient(),
        ),
        _gysrGqlClientController = BehaviorSubject<GraphQLClient>.seeded(
          defaultChain.createGysrGraphQLClient(),
        ) {
    _aptRouterClientController
        .add(defaultChain.createAptRouterClient(_web3ClientController.value));
    _aptFactoryClientController
        .add(defaultChain.createAptFactoryClient(_web3ClientController.value));
  }

  final http.Client _httpClient;

  final _dependenciesController = BehaviorSubject<AppConfig>();

  /// Allows listening to when dependencies change. Used to refetch data that
  /// is based on reactive dependencies.
  Stream<AppConfig> get dependenciesChanges => _dependenciesController.stream;

  final BehaviorSubject<Web3Client> _web3ClientController;
  final _aptRouterClientController = BehaviorSubject<APTRouter>();
  final _aptFactoryClientController = BehaviorSubject<APTFactory>();

  final _lspClientController = BehaviorSubject<LongShortPair>();

  /// Returns the current [LongShortPair] address synchronously.
  String? get currentLspAddress =>
      _lspClientController.valueOrNull?.self.address.hex;

  final BehaviorSubject<GraphQLClient> _dexGqlClientController;
  final BehaviorSubject<GraphQLClient> _gysrGqlClientController;

  /// Creates and returns the initial [AppConfig] which is used to pass down
  /// reactive dependencies.
  AppConfig initializeAppConfig() {
    return AppConfig(
      reactiveWeb3Client: _web3ClientController.stream,
      reactiveAptRouterClient: _aptRouterClientController.stream,
      reactiveAptFactoryClient: _aptFactoryClientController.stream,
      reactiveLspClient: _lspClientController.stream,
      reactiveDexGqlClient: _dexGqlClientController.stream,
      reactiveGysrGqlClient: _gysrGqlClientController.stream,
    );
  }

  /// Switches dependencies and then disposes of the old ones.
  void switchDependencies(EthereumChain chain) {
    if (!chain.isSupported) {
      return;
    }
    final previousWeb3Client = _web3ClientController.valueOrNull;
    final web3Client = chain.createWeb3Client(_httpClient);
    _web3ClientController.add(web3Client);
    previousWeb3Client?.dispose();

    final aptRouterClient = chain.createAptRouterClient(web3Client);
    _aptRouterClientController.add(aptRouterClient);

    final aptFactoryClient = chain.createAptFactoryClient(web3Client);
    _aptFactoryClientController.add(aptFactoryClient);

    final dexGqlClient = chain.createDexGraphQLClient();
    _dexGqlClientController.add(dexGqlClient);

    final gysrGqlClient = chain.createGysrGraphQLClient();
    _gysrGqlClientController.add(gysrGqlClient);

    _dependenciesController.add(initializeAppConfig());
  }

  // /// Switches the [LongShortPair] client.
  // void switchLspClient(String pairAddress) {
  //   final lspClient = LongShortPair(
  //     address: EthereumAddress.fromHex(pairAddress),
  //     client: _web3ClientController.value,
  //   );
  //   _lspClientController.add(lspClient);
  // }
}
