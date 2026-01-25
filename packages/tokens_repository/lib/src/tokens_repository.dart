import 'dart:math' as math;
import 'package:ethereum_api/lsp_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:shared/shared.dart';
import 'package:tokens_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

/// {@template tokens_repository}
/// Repository that manages the token domain.
/// {@endtemplate}
class TokensRepository {
  /// {@macro tokens_repository}
  TokensRepository({
    required TokensApiClient tokensApiClient,
    required ValueStream<LongShortPair> reactiveLspClient,
    http.Client? httpClient,
  })  : _tokensApiClient = tokensApiClient,
        _reactiveLspClient = reactiveLspClient,
        _httpClient = httpClient ?? http.Client(),
        _web3Client = Web3Client('https://polygon-rpc.com', httpClient ?? http.Client());

  final TokensApiClient _tokensApiClient;

  final ValueStream<LongShortPair> _reactiveLspClient;
  LongShortPair get _lspClient => _reactiveLspClient.value;

  final http.Client _httpClient;
  final Web3Client _web3Client;

  // Polygon Mainnet addresses for price oracle
  static const String _axTokenAddress = '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df';
  static const String _usdcAddress = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174';
  static const String _uniswapV3FactoryAddress = '0x1F98431c8aD98523631AE4a59f267346ea31F984';

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

  /// Allows listening to changes to the current [Event]s
  Stream<List<Event>> get eventsChanges =>
      tokensChanges.map((tokens) => tokens.whereType<Event>().toList());

  /// Returns the current [Apt]s synchronously. The returned [Apt]s are
  /// based on the current [EthereumChain].
  List<Apt> get currentApts => currentTokens.whereType<Apt>().toList();

  /// Returns the current [Event]s synchronously.  The returned [Event]s
  /// based on the current [EthereumChain].
  List<Event> get currentEvents => currentTokens.whereType<Event>().toList();

  /// Returns the previous [Apt]s synchronously. The returned [Apt]s are
  /// based on the previous [EthereumChain].
  List<Apt> get previousApts => previousTokens.whereType<Apt>().toList();

  /// Returns the previous [Event]s synchronously.  The returned [Event]s
  /// based on the previous [EthereumChain].
  List<Event> get previousEvents => previousTokens.whereType<Event>().toList();

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

  /// Returns the current [EventPair] for the given [eventId] synchronously.
  /// The returned [EventPair] is based on the current [EthereumChain]
  EventPair currentEventPair(int eventId) =>
      currentEvents.findPairByEventId(eventId);

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

  /// Get AX market data from Uniswap V3
  Future<AxMarketData> getAxMarketData() async {
    try {
      final price = await _getAxPriceFromUniswap();
      return AxMarketData(
        price: price,
        totalSupply: null,
        lastUpdated: DateTime.now().toIso8601String(),
        circulatingSupply: null,
      );
    } catch (e) {
      return AxMarketData.empty;
    }
  }

  /// Get AX price from Uniswap V3 pool on Polygon
  Future<double> _getAxPriceFromUniswap() async {
    try {
      final poolAddress = await _getUniswapPoolAddress();
      if (poolAddress == null) {
        throw Exception('No Uniswap V3 pool found for AX/USDC');
      }
      return await _getPriceFromPool(poolAddress);
    } catch (e) {
      throw Exception('Failed to get AX price from Uniswap: $e');
    }
  }

  /// Find Uniswap V3 pool address for AX/USDC pair
  Future<EthereumAddress?> _getUniswapPoolAddress() async {
    final factory = DeployedContract(
      ContractAbi.fromJson(
        '[{"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"},{"internalType":"uint24","name":"fee","type":"uint24"}],"name":"getPool","outputs":[{"internalType":"address","name":"pool","type":"address"}],"stateMutability":"view","type":"function"}]',
        'UniswapV3Factory',
      ),
      EthereumAddress.fromHex(_uniswapV3FactoryAddress),
    );

    final getPoolFunction = factory.function('getPool');
    final axAddress = EthereumAddress.fromHex(_axTokenAddress);
    final usdcAddress = EthereumAddress.fromHex(_usdcAddress);

    // Try different fee tiers (0.3%, 0.05%, 1%)
    final feeTiers = [3000, 500, 10000];

    for (final fee in feeTiers) {
      final result = await _web3Client.call(
        contract: factory,
        function: getPoolFunction,
        params: [axAddress, usdcAddress, BigInt.from(fee)],
      );

      final poolAddress = result[0] as EthereumAddress;
      if (poolAddress.hex != '0x0000000000000000000000000000000000000000') {
        return poolAddress;
      }
    }

    return null;
  }

  /// Get price from a Uniswap V3 pool
  Future<double> _getPriceFromPool(EthereumAddress poolAddress) async {
    final pool = DeployedContract(
      ContractAbi.fromJson(
        '[{"inputs":[],"name":"slot0","outputs":[{"internalType":"uint160","name":"sqrtPriceX96","type":"uint160"},{"internalType":"int24","name":"tick","type":"int24"},{"internalType":"uint16","name":"observationIndex","type":"uint16"},{"internalType":"uint16","name":"observationCardinality","type":"uint16"},{"internalType":"uint16","name":"observationCardinalityNext","type":"uint16"},{"internalType":"uint8","name":"feeProtocol","type":"uint8"},{"internalType":"bool","name":"unlocked","type":"bool"}],"stateMutability":"view","type":"function"}]',
        'UniswapV3Pool',
      ),
      poolAddress,
    );

    final slot0Function = pool.function('slot0');
    final result = await _web3Client.call(
      contract: pool,
      function: slot0Function,
      params: [],
    );

    final sqrtPriceX96 = result[0] as BigInt;
    return _calculatePriceFromSqrtPriceX96(sqrtPriceX96);
  }

  /// Convert Uniswap V3 sqrtPriceX96 to decimal price
  double _calculatePriceFromSqrtPriceX96(BigInt sqrtPriceX96) {
    // sqrtPriceX96 = sqrt(price) * 2^96
    // price = (sqrtPriceX96 / 2^96)^2
    final q96 = BigInt.from(2).pow(96);
    final sqrtPrice = sqrtPriceX96.toDouble() / q96.toDouble();
    final price = math.pow(sqrtPrice, 2).toDouble();

    // Adjust for decimals: AX has 18 decimals, USDC has 6 decimals
    // Price is in terms of token1/token0, need to check token order
    // Typically: price_usdc_per_ax = price * 10^(18-6) = price * 10^12
    final adjustedPrice = price * math.pow(10, 12).toDouble();

    return adjustedPrice;
  }

  void dispose() {
    _httpClient.close();
  }

  /// Returns the symbol for the [Token] identified by the [tokenAddress].
  ///
  /// Defaults to returning an empty string on error.
  Future<String> getTokenSymbol(String tokenAddress) =>
      _tokensApiClient.getTokenSymbol(tokenAddress);
}
