import 'package:ethereum_api/src/apt_router/apt_router.dart';
import 'package:ethereum_api/src/dex/dex.dart';
import 'package:ethereum_api/src/lsp/lsp.dart';
import 'package:shared/shared.dart';

/// {@template app_config}
/// Holds reactive dependencies.
/// {@endtemplate}
class AppConfig extends Equatable {
  /// {@macro app_config}
  const AppConfig({
    required this.reactiveWeb3Client,
    required this.reactiveAptRouterClient,
    required this.reactiveDexClient,
    required this.reactiveLspClient,
    required this.reactiveDexGqlClient,
    required this.reactiveGysrGqlClient,
  });

  /// Reactive [Web3Client].
  final ValueStream<Web3Client> reactiveWeb3Client;

  /// Reactive [APTRouter] client.
  final ValueStream<APTRouter> reactiveAptRouterClient;

  /// Reactive [Dex] client.
  final ValueStream<Dex> reactiveDexClient;

  /// Reactive [LongShortPair] client.
  final ValueStream<LongShortPair> reactiveLspClient;

  /// Reactive dex [GraphQLClient] client.
  final ValueStream<GraphQLClient> reactiveDexGqlClient;

  /// Reactive gysr [GraphQLClient] client.
  final ValueStream<GraphQLClient> reactiveGysrGqlClient;

  @override
  List<Object?> get props => [
        reactiveWeb3Client,
        reactiveAptRouterClient,
        reactiveDexClient,
        reactiveLspClient,
        reactiveDexGqlClient,
        reactiveGysrGqlClient,
      ];
}
