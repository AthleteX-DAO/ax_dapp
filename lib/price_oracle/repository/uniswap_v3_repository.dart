import 'dart:async';
import 'dart:convert';

import 'package:ax_dapp/price_oracle/models/uniswap_price.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

/// {@template uniswap_v3_repository}
/// Repository for fetching price data from Uniswap V3.
/// {@endtemplate}
class UniswapV3Repository {
  /// {@macro uniswap_v3_repository}
  UniswapV3Repository({
    required String rpcUrl,
    http.Client? httpClient,
  })  : _client = Web3Client(rpcUrl, httpClient ?? http.Client()),
        _httpClient = httpClient ?? http.Client();

  final Web3Client _client;
  final http.Client _httpClient;

  // Polygon Mainnet addresses
  static const String _axTokenAddress =
      '0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df';
  static const String _usdcAddress =
      '0x3c499c542cEF5E3811e1192ce70d8cC03d5c3359'; // USDC on Polygon
  static const String _wmaticAddress =
      '0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270'; // WMATIC (POL)

  // Uniswap V3 addresses on Polygon
  static const String _uniswapV3FactoryAddress =
      '0x1F98431c8aD98523631AE4a59f267346ea31F984';
    // ignore: unused_field
    static const String _uniswapV3QuoterV2Address =
      '0x61fFE014bA17989E743c5F6cB21bF9697530B21e';

  // The Graph Uniswap V3 Polygon endpoint
  static const String _subgraphUrl =
      'https://api.thegraph.com/subgraphs/name/ianlapham/uniswap-v3-polygon';

  /// Get current price of AX in USD via AX/USDC pool
  Future<UniswapPrice> getAxUsdPrice() async {
    try {
      // Get pool address for AX/USDC
      final poolAddress = await _getPoolAddress(_axTokenAddress, _usdcAddress);

      if (poolAddress == EthereumAddress.fromHex(
        '0x0000000000000000000000000000000000000000',
      )) {
        // Pool doesn't exist, return empty price
        return UniswapPrice.empty;
      }

      // Get current price from pool
      final price = await _getPriceFromPool(
        poolAddress,
        _axTokenAddress,
        _usdcAddress,
      );

      return price;
    } catch (e) {
      print('Error fetching AX/USD price: $e');
      return UniswapPrice.empty;
    }
  }

  /// Get current price of AX in POL (MATIC) via AX/WMATIC pool
  Future<UniswapPrice> getAxPolPrice() async {
    try {
      final poolAddress = await _getPoolAddress(
        _axTokenAddress,
        _wmaticAddress,
      );

      if (poolAddress == EthereumAddress.fromHex(
        '0x0000000000000000000000000000000000000000',
      )) {
        return UniswapPrice.empty;
      }

      final price = await _getPriceFromPool(
        poolAddress,
        _axTokenAddress,
        _wmaticAddress,
      );

      return price;
    } catch (e) {
      print('Error fetching AX/POL price: $e');
      return UniswapPrice.empty;
    }
  }

  /// Get pool address from Uniswap V3 Factory
  Future<EthereumAddress> _getPoolAddress(
    String token0,
    String token1,
  ) async {
    final factoryAbi = ContractAbi.fromJson(
      '''
      [
        {
          "inputs": [
            {"internalType": "address", "name": "tokenA", "type": "address"},
            {"internalType": "address", "name": "tokenB", "type": "address"},
            {"internalType": "uint24", "name": "fee", "type": "uint24"}
          ],
          "name": "getPool",
          "outputs": [
            {"internalType": "address", "name": "pool", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        }
      ]
      ''',
      'UniswapV3Factory',
    );

    final factory = DeployedContract(
      factoryAbi,
      EthereumAddress.fromHex(_uniswapV3FactoryAddress),
    );

    final getPoolFunction = factory.function('getPool');

    // Try different fee tiers (3000 = 0.3%, 500 = 0.05%, 10000 = 1%)
    for (final fee in [3000, 500, 10000]) {
      final result = await _client.call(
        contract: factory,
        function: getPoolFunction,
        params: [
          EthereumAddress.fromHex(token0),
          EthereumAddress.fromHex(token1),
          BigInt.from(fee),
        ],
      );

      final poolAddress = result.first as EthereumAddress;

      if (poolAddress != EthereumAddress.fromHex(
        '0x0000000000000000000000000000000000000000',
      )) {
        return poolAddress;
      }
    }

    return EthereumAddress.fromHex(
      '0x0000000000000000000000000000000000000000',
    );
  }

  /// Get current price from Uniswap V3 pool using slot0
  Future<UniswapPrice> _getPriceFromPool(
    EthereumAddress poolAddress,
    String token0Address,
    String token1Address,
  ) async {
    final poolAbi = ContractAbi.fromJson(
      '''
      [
        {
          "inputs": [],
          "name": "slot0",
          "outputs": [
            {"internalType": "uint160", "name": "sqrtPriceX96", "type": "uint160"},
            {"internalType": "int24", "name": "tick", "type": "int24"},
            {"internalType": "uint16", "name": "observationIndex", "type": "uint16"},
            {"internalType": "uint16", "name": "observationCardinality", "type": "uint16"},
            {"internalType": "uint16", "name": "observationCardinalityNext", "type": "uint16"},
            {"internalType": "uint8", "name": "feeProtocol", "type": "uint8"},
            {"internalType": "bool", "name": "unlocked", "type": "bool"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "liquidity",
          "outputs": [
            {"internalType": "uint128", "name": "", "type": "uint128"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "token0",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "token1",
          "outputs": [
            {"internalType": "address", "name": "", "type": "address"}
          ],
          "stateMutability": "view",
          "type": "function"
        }
      ]
      ''',
      'UniswapV3Pool',
    );

    final pool = DeployedContract(poolAbi, poolAddress);

    // Get slot0 data
    final slot0Result = await _client.call(
      contract: pool,
      function: pool.function('slot0'),
      params: [],
    );

    final sqrtPriceX96 = slot0Result[0] as BigInt;

    // Get liquidity
    final liquidityResult = await _client.call(
      contract: pool,
      function: pool.function('liquidity'),
      params: [],
    );

    final liquidity = liquidityResult.first as BigInt;

    // Get token order from pool
    final token0Result = await _client.call(
      contract: pool,
      function: pool.function('token0'),
      params: [],
    );
    final poolToken0 = (token0Result.first as EthereumAddress).hex;

    // Calculate price from sqrtPriceX96
    // price = (sqrtPriceX96 / 2^96)^2
    final price = _calculatePriceFromSqrtPriceX96(sqrtPriceX96);

    // Determine if we need to invert the price
    final isToken0AX = poolToken0.toLowerCase() == token0Address.toLowerCase();
    final token0Price = isToken0AX ? price : 1 / price;
    final token1Price = isToken0AX ? 1 / price : price;

    // For AX/USDC, USDC is typically token1, so token0Price is AX price in USD
    // For AX/WMATIC, we need to get WMATIC price in USD separately
    final priceUSD = token1Address.toLowerCase() == _usdcAddress.toLowerCase()
        ? token0Price
        : 0.0; // TODO: Implement WMATIC to USD conversion

    return UniswapPrice(
      priceUSD: priceUSD,
      token0Price: token0Price,
      token1Price: token1Price,
      timestamp: DateTime.now(),
      liquidity: liquidity.toDouble(),
    );
  }

  /// Calculate price from sqrtPriceX96
  double _calculatePriceFromSqrtPriceX96(BigInt sqrtPriceX96) {
    // price = (sqrtPriceX96 / 2^96)^2
    final q96 = BigInt.from(2).pow(96);
    final sqrtPrice = sqrtPriceX96.toDouble() / q96.toDouble();
    return sqrtPrice * sqrtPrice;
  }

  /// Get historical price data from The Graph
  Future<List<HistoricalPrice>> getHistoricalPrices({
    required String poolAddress,
    required int periodInHours,
  }) async {
    try {
      final endTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final startTime = endTime - (periodInHours * 3600);

      final query = '''
        query {
          poolHourDatas(
            first: $periodInHours
            where: {
              pool: "${poolAddress.toLowerCase()}"
              periodStartUnix_gte: $startTime
              periodStartUnix_lte: $endTime
            }
            orderBy: periodStartUnix
            orderDirection: asc
          ) {
            periodStartUnix
            open
            high
            low
            close
            volumeUSD
          }
        }
      ''';

      final response = await _httpClient.post(
        Uri.parse(_subgraphUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final poolHourDatas =
            data['data']['poolHourDatas'] as List<dynamic>? ?? [];

        return poolHourDatas
            .map((hourData) => HistoricalPrice(
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                    (hourData['periodStartUnix'] as int) * 1000,
                  ),
                  open: double.parse(hourData['open'].toString()),
                  high: double.parse(hourData['high'].toString()),
                  low: double.parse(hourData['low'].toString()),
                  close: double.parse(hourData['close'].toString()),
                  volume: double.parse(hourData['volumeUSD'].toString()),
                ),)
            .toList();
      }

      return [];
    } catch (e) {
      print('Error fetching historical prices: $e');
      return [];
    }
  }

  /// Get pool data including 24h volume and price change
  Future<Map<String, dynamic>> getPoolStats(String poolAddress) async {
    try {
      final query = '''
        query {
          pool(id: "${poolAddress.toLowerCase()}") {
            token0Price
            token1Price
            volumeUSD
            liquidity
            txCount
          }
          poolDayDatas(
            first: 2
            where: { pool: "${poolAddress.toLowerCase()}" }
            orderBy: date
            orderDirection: desc
          ) {
            date
            volumeUSD
            tvlUSD
            open
            close
          }
        }
      ''';

      final response = await _httpClient.post(
        Uri.parse(_subgraphUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['data'] as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      print('Error fetching pool stats: $e');
      return {};
    }
  }

  void dispose() {
    _client.dispose();
    _httpClient.close();
  }
}
