import 'dart:developer' as developer;
import 'package:web3dart/web3dart.dart' hide Credentials;
import 'package:http/http.dart' as http;
import '../config/oracle_config.dart';
import '../models/price_feed.dart';

/// Pure Dart Chainlink oracle client
/// No Flutter dependencies, no business logic
/// Calls latestRoundData() on Chainlink aggregator contracts
class ChainlinkOracleClient {
  ChainlinkOracleClient({
    required String rpcUrl,
    this.timeout = const Duration(seconds: 30),
  }) : _rpcUrl = rpcUrl {
    print('🔗 [ChainlinkOracleClient] Initializing with RPC: $rpcUrl');
  }

  final String _rpcUrl;
  final Duration timeout;
  Web3Client? _web3Client;

  /// Initialize the Web3 client (lazy initialization)
  Future<void> _ensureInitialized() async {
    if (_web3Client == null) {
      print('🔗 [ChainlinkOracleClient] Creating Web3Client for RPC');
      _web3Client = Web3Client(_rpcUrl, http.Client());
    }
  }

  /// Fetch latest price from Chainlink aggregator contract
  /// 
  /// Parameters:
  ///   - symbol: Asset symbol (e.g., 'ETH', 'BTC')
  ///   - aggregatorAddress: Chainlink aggregator contract address
  /// 
  /// Returns: PriceFeed with latest price data
  /// 
  /// Throws: Exception if RPC call fails or price is stale
  Future<PriceFeed> getLatestPrice(
    String symbol,
    String aggregatorAddress,
  ) async {
    print(
      '🔗 [ChainlinkOracleClient] Fetching $symbol from $aggregatorAddress',
    );

    try {
      await _ensureInitialized();

      final address = EthereumAddress.fromHex(aggregatorAddress);

      // Chainlink aggregator ABI for latestRoundData
      // latestRoundData() returns:
      // (roundId, answer, startedAt, updatedAt, answeredInRound)
      const abiJson = '''[
        {
          "name": "latestRoundData",
          "outputs": [
            {"type": "uint80", "name": "roundId"},
            {"type": "int256", "name": "answer"},
            {"type": "uint256", "name": "startedAt"},
            {"type": "uint256", "name": "updatedAt"},
            {"type": "uint80", "name": "answeredInRound"}
          ],
          "type": "function",
          "stateMutability": "view"
        },
        {
          "name": "decimals",
          "outputs": [{"type": "uint8", "name": ""}],
          "type": "function",
          "stateMutability": "view"
        }
      ]''';

      final contract = DeployedContract(
        ContractAbi.fromJson(abiJson, 'ChainlinkAggregator'),
        address,
      );

      print('🔗 [ChainlinkOracleClient] Calling latestRoundData()');

      // Call latestRoundData() with timeout
      final roundDataFuture = _web3Client!.call(
        contract: contract,
        function: contract.function('latestRoundData'),
        params: [],
      );

      final roundData = await roundDataFuture.timeout(
        timeout,
        onTimeout: () {
          throw Exception(
            '🔗 [ChainlinkOracleClient] Timeout calling latestRoundData for $symbol',
          );
        },
      );

      print('🔗 [ChainlinkOracleClient] Got raw round data: $roundData');

      // Parse response: [roundId, answer, startedAt, updatedAt, answeredInRound]
      final answer = roundData[1] as BigInt;
      final updatedAt = roundData[3] as BigInt;

      if (answer == BigInt.zero) {
        throw Exception(
          '🔗 [ChainlinkOracleClient] Invalid price data (answer is 0) for $symbol',
        );
      }

      // Chainlink feeds are 8 decimals
      final price = _formatPrice(answer, OracleConfig.chainlinkDecimalPlaces);
      final timestamp = updatedAt.toInt() * 1000; // Convert to milliseconds

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final priceAge = now - updatedAt.toInt();

      print(
        '🔗 [ChainlinkOracleClient] ✓ Fetched $symbol: '
        'price=$price, age=${priceAge}s, timestamp=$timestamp',
      );

      return PriceFeed(
        symbol: symbol,
        price: price,
        decimals: OracleConfig.chainlinkDecimalPlaces,
        timestamp: timestamp,
        source: PriceFeedSource.chainlink,
        rawData: {
          'roundId': roundData[0].toString(),
          'answer': answer.toString(),
          'startedAt': roundData[2].toString(),
          'updatedAt': updatedAt.toString(),
          'answeredInRound': roundData[4].toString(),
          'ageSeconds': priceAge,
        },
      );
    } catch (e, stackTrace) {
      print(
        '❌ [ChainlinkOracleClient] Error fetching $symbol: $e',
      );
      developer.log(
        'ChainlinkOracleClient error for $symbol',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Fetch multiple prices in parallel
  Future<List<PriceFeed>> getMultiplePrices(
    Map<String, String> symbolAddressPairs,
  ) async {
    print(
      '🔗 [ChainlinkOracleClient] Fetching ${symbolAddressPairs.length} prices',
    );

    final futures = symbolAddressPairs.entries.map(
      (entry) => getLatestPrice(entry.key, entry.value),
    );

    return Future.wait(futures);
  }

  /// Convert BigInt price to double based on decimals
  double _formatPrice(BigInt answer, int decimals) {
    final divisor = BigInt.from(10).pow(decimals);
    final wholePart = answer ~/ divisor;
    final fractionalPart = answer % divisor;

    final fractionalValue = fractionalPart.toDouble() / divisor.toDouble();
    return wholePart.toDouble() + fractionalValue;
  }

  /// Cleanup Web3Client resources
  Future<void> dispose() async {
    print('🔗 [ChainlinkOracleClient] Disposing Web3Client');
    if (_web3Client != null) {
      _web3Client!.dispose();
    }
  }
}
