import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart' hide Credentials;
import 'package:ax_dapp/repositories/oracle/config/oracle_config.dart';
import 'package:ax_dapp/repositories/oracle/models/price_feed.dart';

/// Pure Dart Optimistic ZK oracle client
/// No Flutter dependencies, no business logic
/// Calls getPrice(string) on OptimisticZKPriceOracle contracts
class OptimisticZkOracleClient {
  OptimisticZkOracleClient({
    required String rpcUrl,
    required String contractAddress,
    this.timeout = const Duration(seconds: 20),
  })  : _rpcUrl = rpcUrl,
        _contractAddress = contractAddress {
    print('🧪 [OptimisticZkOracleClient] Initializing with RPC: $rpcUrl');
  }

  final String _rpcUrl;
  final String _contractAddress;
  final Duration timeout;
  Web3Client? _web3Client;

  Future<void> _ensureInitialized() async {
    if (_web3Client == null) {
      print('🧪 [OptimisticZkOracleClient] Creating Web3Client for RPC');
      _web3Client = Web3Client(_rpcUrl, http.Client());
    }
  }

  Future<PriceFeed> getLatestPrice(String symbol) async {
    print('🧪 [OptimisticZkOracleClient] Fetching $symbol from $_contractAddress');

    try {
      await _ensureInitialized();

      final address = EthereumAddress.fromHex(_contractAddress);

      const abiJson = '''
[
        {
          "name": "getPrice",
          "inputs": [{"type": "string", "name": "asset"}],
          "outputs": [{"type": "uint256", "name": "price"}],
          "type": "function",
          "stateMutability": "view"
        }
      ]''';

      final contract = DeployedContract(
        ContractAbi.fromJson(abiJson, 'OptimisticZkPriceOracle'),
        address,
      );

      final priceFuture = _web3Client!.call(
        contract: contract,
        function: contract.function('getPrice'),
        params: [symbol],
      );

      final result = await priceFuture.timeout(
        timeout,
        onTimeout: () {
          throw Exception(
            '🧪 [OptimisticZkOracleClient] Timeout calling getPrice for $symbol',
          );
        },
      );

      if (result.isEmpty) {
        throw Exception('🧪 [OptimisticZkOracleClient] Empty response for $symbol');
      }

      final rawPrice = result.first as BigInt;
      if (rawPrice == BigInt.zero) {
        throw Exception('🧪 [OptimisticZkOracleClient] Invalid price (0) for $symbol');
      }

      final price = _formatPrice(
        rawPrice,
        OracleConfig.optimisticZkOracleDecimals,
      );
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      print('🧪 [OptimisticZkOracleClient] ✓ Fetched $symbol: $price');

      return PriceFeed(
        symbol: symbol,
        price: price,
        decimals: OracleConfig.optimisticZkOracleDecimals,
        timestamp: timestamp,
        source: PriceFeedSource.optimisticZk,
        rawData: {
          'price': rawPrice.toString(),
        },
      );
    } catch (e, stackTrace) {
      print('❌ [OptimisticZkOracleClient] Error fetching $symbol: $e');
      developer.log(
        'OptimisticZkOracleClient error for $symbol',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  double _formatPrice(BigInt answer, int decimals) {
    final divisor = BigInt.from(10).pow(decimals);
    final wholePart = answer ~/ divisor;
    final fractionalPart = answer % divisor;

    final fractionalValue = fractionalPart.toDouble() / divisor.toDouble();
    return wholePart.toDouble() + fractionalValue;
  }

  Future<void> dispose() async {
    print('🧪 [OptimisticZkOracleClient] Disposing Web3Client');
    _web3Client?.dispose();
  }
}
