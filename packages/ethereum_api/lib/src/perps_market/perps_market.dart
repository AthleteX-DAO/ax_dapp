import 'package:web3dart/web3dart.dart';

/// Represents a Synthetix V3 Perps Market contract interface.
/// Calls `getMarketSummary(uint128)` which returns a struct:
///   (int256 skew, uint256 size, uint256 maxOpenInterest,
///    int256 currentFundingRate, int256 currentFundingVelocity,
///    uint256 indexPrice)
class PerpsMarket {

  PerpsMarket({
    required this.address,
    required this.client,
  }) {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abi, 'PerpsMarketProxy'),
      address,
    );
  }
  /// The contract address
  final EthereumAddress address;

  /// The web3 client
  final Web3Client client;

  late final DeployedContract _contract;

  // ── Market IDs — TODO: update when perps are deployed on Eth Sepolia ──
  // These were from the Arb Sepolia omnibus deployment
  static const int ETH_MARKET_ID = 100;
  static const int BTC_MARKET_ID = 200;
  static const int SOL_MARKET_ID = 300;

  /// Canonical symbol → marketId mapping (verified on-chain via metadata()).
  static const Map<String, int> marketIds = {
    'ETH': 100,
    'BTC': 200,
    'SOL': 300,
    'LINK': 500,
    'ARB': 600,
    'DOGE': 700,
    'BNB': 1700,
    'XRP': 1200,
    'ADA': 2500,
  };

  /// Data class for the MarketSummary struct returned by getMarketSummary.
  /// All values are raw BigInt (18-decimal scaled).

  /// Fetches the full market summary in a single RPC call.
  /// Returns null if the oracle data is stale (ERC-7412 revert).
  Future<MarketSummaryData?> getMarketSummary(int marketId) async {
    try {
      final fn = _contract.function('getMarketSummary');
      final result = await client.call(
        contract: _contract,
        function: fn,
        params: [BigInt.from(marketId)],
      );
      // Result is a list of 6 values matching the struct fields
      if (result.isEmpty) return null;

      // web3dart returns the tuple as a flat list
      final values = result.length == 1 && result[0] is List
          ? result[0] as List
          : result;

      return MarketSummaryData(
        skew: values[0] as BigInt,
        size: values[1] as BigInt,
        maxOpenInterest: values[2] as BigInt,
        currentFundingRate: values[3] as BigInt,
        currentFundingVelocity: values[4] as BigInt,
        indexPrice: values[5] as BigInt,
      );
    } catch (e) {
      // ERC-7412 OracleDataRequired or other RPC error
      print('getMarketSummary($marketId) failed: $e');
      return null;
    }
  }

  /// Fetches the current index price for a given market.
  /// Falls back to zero on failure (stale oracle).
  Future<BigInt> getPrice(int marketId) async {
    final summary = await getMarketSummary(marketId);
    return summary?.indexPrice ?? BigInt.zero;
  }

  /// Fetches the current funding rate for a given market.
  Future<BigInt> getFundingRate(int marketId) async {
    final summary = await getMarketSummary(marketId);
    return summary?.currentFundingRate ?? BigInt.zero;
  }

  /// Fetches the open interest (size) for a market.
  Future<BigInt> getOpenInterest(int marketId) async {
    final summary = await getMarketSummary(marketId);
    return summary?.size ?? BigInt.zero;
  }

  /// Fetches the skew for a market.
  Future<BigInt> getSkew(int marketId) async {
    final summary = await getMarketSummary(marketId);
    return summary?.skew ?? BigInt.zero;
  }

  /// Minimal ABI for the PerpsMarketProxy read functions we use.
  static const String _abi = '''
[
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "getMarketSummary",
      "outputs": [
        {
          "components": [
            {"name": "skew", "type": "int256"},
            {"name": "size", "type": "uint256"},
            {"name": "maxOpenInterest", "type": "uint256"},
            {"name": "currentFundingRate", "type": "int256"},
            {"name": "currentFundingVelocity", "type": "int256"},
            {"name": "indexPrice", "type": "uint256"}
          ],
          "name": "summary",
          "type": "tuple"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "indexPrice",
      "outputs": [{"name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "metadata",
      "outputs": [
        {"name": "name", "type": "string"},
        {"name": "symbol", "type": "string"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "skew",
      "outputs": [{"name": "", "type": "int256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "size",
      "outputs": [{"name": "", "type": "uint256"}],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [{"name": "perpsMarketId", "type": "uint128"}],
      "name": "currentFundingRate",
      "outputs": [{"name": "", "type": "int256"}],
      "stateMutability": "view",
      "type": "function"
    }
  ]''';
}

/// Structured result from getMarketSummary().
class MarketSummaryData {
  const MarketSummaryData({
    required this.skew,
    required this.size,
    required this.maxOpenInterest,
    required this.currentFundingRate,
    required this.currentFundingVelocity,
    required this.indexPrice,
  });

  final BigInt skew;
  final BigInt size;
  final BigInt maxOpenInterest;
  final BigInt currentFundingRate;
  final BigInt currentFundingVelocity;
  final BigInt indexPrice;
}
