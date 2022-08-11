import 'package:coingecko_api/coingecko_api.dart';
import 'package:ethereum_api/ethereum_api.dart';
import 'package:ethereum_api/lsp_api.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/src/models/models.dart';

/// {@template tokens_repository}
/// Repository that manages the token domain.
/// {@endtemplate}
class TokensRepository {
  /// {@macro tokens_repository}
  TokensRepository({
    required EthereumApiClient ethereumApiClient,
    required LongShortPair lspClient,
    CoinGeckoApi? coinGeckoApiClient,
  })  : _ethereumApiClient = ethereumApiClient,
        _lspClient = lspClient,
        _coinGeckoApiClient = coinGeckoApiClient ??
            CoinGeckoApi(
              rateLimitManagement: false,
              enableLogging: false,
            );

  final EthereumApiClient _ethereumApiClient;
  final LongShortPair _lspClient;
  final CoinGeckoApi _coinGeckoApiClient;

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

  /// Allows listening to changes to the [Token.ax] associated with the current
  /// [EthereumChain].
  Stream<Token> get axtChanges => tokensChanges.map((tokens) => tokens.axt);

  /// Returns the [Token.ax] associated with the current [EthereumChain],
  /// synchronously.
  Token get currentAxt => tokens.axt;

  /// Allows switching the current [Token]s, which are set based on the current
  /// [EthereumChain].
  void switchTokens(EthereumChain chain) =>
      _ethereumApiClient.switchTokens(chain);

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
      final result = await _coinGeckoApiClient.coins.getCoinData(
        id: 'athletex',
        localization: false,
        communityData: false,
        tickers: false,
        developerData: false,
      );
      final axData = result.data;
      final axMarketData = axData?.marketData;
      final axDataByCurrency = axMarketData?.dataByCurrency;
      final axMarketDataByUsd = axDataByCurrency?.firstWhereOrNull(
        (marketData) => marketData.coinId.toLowerCase() == 'usd',
      );
      final axPrice = axMarketDataByUsd?.currentPrice;
      final axTotalSupply = axMarketData?.totalSupply;
      final axCirculatingSupply = axMarketData?.circulatingSupply;
      return AxMarketData(
        price: axPrice,
        totalSupply: axTotalSupply,
        circulatingSupply: axCirculatingSupply,
      );
    } catch (_) {
      return AxMarketData.empty;
    }
  }

  /// Returns the symbol for the [Token] identified by the [tokenAddress].
  ///
  /// Defaults to returning an empty string on error.
  Future<String> getTokenSymbol(String tokenAddress) =>
      _ethereumApiClient.getTokenSymbol(tokenAddress);
}
