import 'package:ethereum_api/ethereum_api.dart';
import 'package:ethereum_api/lsp_api.dart';

/// {@template tokens_repository}
/// Repository that manages the token domain.
/// {@endtemplate}
class TokensRepository {
  /// {@macro tokens_repository}
  TokensRepository({
    required EthereumApiClient ethereumApiClient,
    required LongShortPair lspClient,
  })  : _ethereumApiClient = ethereumApiClient,
        _lspClient = lspClient;

  final EthereumApiClient _ethereumApiClient;
  final LongShortPair _lspClient;

  /// Allows listening to changes to the current [Token]s.
  Stream<List<Token>> get tokensChanges => _ethereumApiClient.tokensChanges;

  /// Returns the current [Token]s synchronously. The returned [Token]s are
  /// based on the current [EthereumChain].
  List<Token> get tokens => _ethereumApiClient.tokens;

  /// Allows listening to changes to the current [Apt]s.
  Stream<List<Apt>> get aptsChanges => _ethereumApiClient.aptsChanges;

  /// Returns the current [Apt]s synchronously. The returned [Apt]s are
  /// based on the current [EthereumChain].
  List<Apt> get apts => _ethereumApiClient.apts;

  /// Allows listening to changes to the [Apt]s (long and short) for the
  /// athlete identified by [athleteId].
  Stream<AptPair> aptPairChanges(int athleteId) =>
      _ethereumApiClient.aptPairChanges(athleteId);

  /// Returns the current [AptPair] for the given [athleteId] synchronously.
  /// The returned [AptPair] is based on the current [EthereumChain].
  AptPair aptPair(int athleteId) => _ethereumApiClient.aptPair(athleteId);

  /// Allows listening to changes to the [Token] associated with the current
  /// [EthereumChain].
  Stream<Token> get chainTokenChanges => tokensChanges.map(_chainTokenMapper);

  /// Returns the [Token] associated with the current [EthereumChain],
  /// synchronously.
  Token get chainToken => _chainTokenMapper(tokens);

  /// Allows switching the current [Token]s, which are set based on the current
  /// [EthereumChain].
  void switchTokens(EthereumChain chain) =>
      _ethereumApiClient.switchTokens(chain);

  Token _chainTokenMapper(List<Token> tokens) {
    final tokensChain = tokens.first.chain;
    switch (tokensChain) {
      case EthereumChain.none:
      case EthereumChain.unsupported:
        return Token.empty;
      case EthereumChain.polygonMainnet:
      case EthereumChain.polygonTestnet:
        return tokens.axt;
      case EthereumChain.sxMainnet:
      case EthereumChain.sxTestnet:
        return tokens.sxt;
    }
  }

  /// Returns the collateral value per pair. In case of an error it returns
  /// [BigInt.zero].
  Future<BigInt> getCollateralPerPair() async {
    try {
      final collateralValue = await _lspClient.collateralPerPair();
      final normalizedCollateralValue =
          collateralValue ~/ BigInt.from(10).pow(18); // removes 18 zeros
      return normalizedCollateralValue;
    } catch (_) {
      return BigInt.zero;
    }
  }
}
