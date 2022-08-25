import 'package:ethereum_api/config_api.dart';
import 'package:ethereum_api/lsp_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:ethereum_api/wallet_api.dart';

/// {@template config_repository}
/// Repository that manages configurations.
/// {@endtemplate}
class ConfigRepository {
  /// {@macro config_repository}
  ConfigRepository({
    required ConfigApiClient configApiClient,
  }) : _configApiClient = configApiClient;

  final ConfigApiClient _configApiClient;

  /// Allows listening to when dependencies change. Used to refetch data that
  /// is based on reactive dependencies.
  Stream<AppConfig> get dependenciesChanges =>
      _configApiClient.dependenciesChanges;

  /// Returns the current [LongShortPair] address synchronously.
  String? get currentLspAddress => _configApiClient.currentLspAddress;

  /// Creates and returns the initial [AppConfig] which is used to pass down
  /// reactive dependencies.
  AppConfig initializeAppConfig() => _configApiClient.initializeAppConfig();

  /// Switches dependencies and then disposes of the old ones.
  void switchDependencies(EthereumChain chain) =>
      _configApiClient.switchDependencies(chain);

  // /// Switches the [LongShortPair] client.
  // void switchLspClient(String pairAddress) =>
  //     _configApiClient.switchLspClient(pairAddress);
}
