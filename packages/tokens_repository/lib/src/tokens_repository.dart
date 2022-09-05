import 'package:ethereum_api/lsp_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/src/api/coin_gecko_api.dart';
import 'package:tokens_repository/src/models/models.dart';

/// {@template tokens_repository}
/// Repository that manages the token domain.
/// {@endtemplate}
class TokensRepository {
  /// {@macro tokens_repository}
  TokensRepository({
    required TokensApiClient tokensApiClient,
    required ValueStream<LongShortPair> reactiveLspClient,
    required CoinGeckoAPI coinGeckoApiClient,
  })  : _tokensApiClient = tokensApiClient,
        _reactiveLspClient = reactiveLspClient,
        _coinGeckoApiClient = coinGeckoApiClient;

  final TokensApiClient _tokensApiClient;

  final ValueStream<LongShortPair> _reactiveLspClient;
  LongShortPair get _lspClient => _reactiveLspClient.value;

  final CoinGeckoAPI _coinGeckoApiClient;

  /// Allows listening to changes to the current [Token]s.
  Stream<List<Token>> get tokensChanges => _tokensApiClient.tokensChanges;

  /// Returns the current [Token]s synchronously. The returned [Token]s are
  /// based on the current [EthereumChain].
  List<Token> get currentTokens => _tokensApiClient.currentTokens;

  /// Returns the previous [Token]s synchronously. The returned [Token]s are
  /// based on the previous [EthereumChain].
  ///
  /// Defaults to an empty list when there's no previous [EthereumChain],
  /// meaning the wallet was not yet connected or it was just connected but the
  /// chain wasn't yet changed.
  List<Token> get previousTokens => _tokensApiClient.previousTokens;

  /// Allows listening to changes to the current [Apt]s.
  Stream<List<Apt>> get aptsChanges =>
      tokensChanges.map((tokens) => tokens.whereType<Apt>().toList());

  /// Returns the current [Apt]s synchronously. The returned [Apt]s are
  /// based on the current [EthereumChain].
  List<Apt> get currentApts => currentTokens.whereType<Apt>().toList();

  /// Returns the previous [Apt]s synchronously. The returned [Apt]s are
  /// based on the previous [EthereumChain].
  List<Apt> get previousApts => previousTokens.whereType<Apt>().toList();

  /// Allows listening to changes to the [Apt]s (long and short) for the
  /// athlete identified by [athleteId].
  Stream<AptPair> aptPairChanges(int athleteId) =>
      tokensChanges.map((tokens) => tokens.whereType<Apt>()).map(
            (apts) => apts.findPairByAthleteId(athleteId),
          );

  /// Returns the current [AptPair] for the given [athleteId] synchronously.
  /// The returned [AptPair] is based on the current [EthereumChain].
  AptPair currentAptPair(int athleteId) =>
      currentApts.findPairByAthleteId(athleteId);

  /// Allows listening to changes to the [Token.ax] associated with the current
  /// [EthereumChain].
  Stream<Token> get axtChanges => tokensChanges.map((tokens) => tokens.axt);

  /// Returns the [Token.ax] associated with the current [EthereumChain],
  /// synchronously.
  Token get currentAxt => currentTokens.axt;

  /// Allows switching the current [Token]s, which are set based on the current
  /// [EthereumChain].
  void switchTokens(EthereumChain chain) =>
      _tokensApiClient.switchTokens(chain);

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

  /// Returns `AthleteX` market data: price, total supply and circulating
  /// supply.
  ///
  /// Defaults to [AxMarketData.empty] if data fetch fails.
  Future<AxMarketData> getAxMarketData() async {
    try {
      final coinData = await _coinGeckoApiClient.getAthleteXCoinData();
      final price = coinData.marketData?.currentPrice?['usd'];

      return AxMarketData(
        price: price,
        totalSupply: coinData.marketData?.totalSupply,
        lastUpdated: coinData.lastUpdated,
        circulatingSupply: coinData.marketData?.circulatingSupply,
      );
    } catch (e) {
      return AxMarketData.empty;
    }
  }

  /// Returns the symbol for the [Token] identified by the [tokenAddress].
  ///
  /// Defaults to returning an empty string on error.
  Future<String> getTokenSymbol(String tokenAddress) =>
      _tokensApiClient.getTokenSymbol(tokenAddress);
}
