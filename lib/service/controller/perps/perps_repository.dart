import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ethereum_api/perps_market_api.dart';
import 'package:web3dart/web3dart.dart';

/// Data transfer object for Perps market data (any symbol).
class PerpsMarketData {

  PerpsMarketData({
    required this.symbol,
    required this.price,
    required this.fundingRate,
    required this.openInterest,
    required this.skew,
    required this.makerFee,
    required this.takerFee,
    required this.timestamp,
  });

  /// Market symbol (e.g., 'BTC', 'ETH')
  final String symbol;
  /// Current price in wei
  final BigInt price;

  /// Current funding rate (scaled by 1e18)
  final BigInt fundingRate;

  /// Open interest in wei
  final BigInt openInterest;

  /// Market skew (long - short imbalance)
  final BigInt skew;

  /// Maker fee rate (scaled by 1e18)
  final BigInt makerFee;

  /// Taker fee rate (scaled by 1e18)
  final BigInt takerFee;

  /// Last updated timestamp
  final DateTime timestamp;

  /// Converts price from wei to readable format (with decimals).
  double get priceInUSD => price.toDouble() / 1e18;

  /// Converts funding rate to percentage per 8h.
  /// Synthetix V3 returns currentFundingRate scaled by 1e18 as a daily rate.
  double get fundingRatePercentage => (fundingRate.toDouble() / 1e18) * 100;

  /// Open interest in USD (size is in native units, multiply by price).
  double get openInterestUSD {
    final nativeOI = openInterest.toDouble() / 1e18;
    final px = price.toDouble() / 1e18;
    return nativeOI * px;
  }

  /// Skew in USD (skew is in native units, multiply by price).
  double get skewUSD {
    final nativeSkew = skew.toDouble() / 1e18;
    final px = price.toDouble() / 1e18;
    return nativeSkew * px;
  }

  /// Converts maker fee from wei to percentage.
  double get makerFeePercentage => (makerFee.toDouble() / 1e18) * 100;

  /// Converts taker fee from wei to percentage.
  double get takerFeePercentage => (takerFee.toDouble() / 1e18) * 100;

  @override
  String toString() {
    return 'PerpsMarketData($symbol: ${priceInUSD.toStringAsFixed(2)} USD, '
        'fundingRate: ${fundingRatePercentage.toStringAsFixed(4)}%, '
        'openInterest: ${openInterestUSD.toStringAsFixed(0)} USD, '
        'skew: ${skewUSD.toStringAsFixed(0)} USD, '
        'makerFee: ${makerFeePercentage.toStringAsFixed(4)}%, '
        'takerFee: ${takerFeePercentage.toStringAsFixed(4)}%)';
  }
}

/// Repository for fetching Synthetix V3 Perps market data.
/// Chain configuration is driven by [SynthetixConfig].
class PerpsRepository {

  PerpsRepository({required Web3Client web3Client})
      : _web3Client = web3Client {
    final perpsAddress = EthereumAddress.fromHex(
      SynthetixConfig.perpsMarketProxy,
    );
    _perpsMarket = PerpsMarket(
      address: perpsAddress,
      client: _web3Client,
    );
  }
  final Web3Client _web3Client;
  late final PerpsMarket _perpsMarket;

  /// Market IDs — delegates to canonical mapping in PerpsMarket.
  static Map<String, int> get marketIds => PerpsMarket.marketIds;

  /// Fetches perps data for any supported [symbol].
  /// Uses `getMarketSummary()` for a single RPC call per market.
  Future<PerpsMarketData> getMarketData(String symbol) async {
    final marketId = marketIds[symbol];
    if (marketId == null) {
      throw ArgumentError('Unsupported perps market: $symbol');
    }
    try {
      final summary = await _perpsMarket.getMarketSummary(marketId);

      if (summary == null) {
        // Oracle stale (ERC-7412) — return zeroed data so UI shows "--"
        return PerpsMarketData(
          symbol: symbol,
          price: BigInt.zero,
          fundingRate: BigInt.zero,
          openInterest: BigInt.zero,
          skew: BigInt.zero,
          makerFee: BigInt.zero,
          takerFee: BigInt.zero,
          timestamp: DateTime.now(),
        );
      }

      return PerpsMarketData(
        symbol: symbol,
        price: summary.indexPrice,
        fundingRate: summary.currentFundingRate,
        openInterest: summary.size,
        skew: summary.skew,
        makerFee: BigInt.zero,
        takerFee: BigInt.zero,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching $symbol Perps data: $e');
      // Return zeroed data on error — UI will show dashes
      return PerpsMarketData(
        symbol: symbol,
        price: BigInt.zero,
        fundingRate: BigInt.zero,
        openInterest: BigInt.zero,
        skew: BigInt.zero,
        makerFee: BigInt.zero,
        takerFee: BigInt.zero,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Convenience alias for BTC.
  Future<PerpsMarketData> getBtcPerpsData() => getMarketData('BTC');

  /// Fetches only the BTC price from the Perps market.
  Future<double> getBtcPrice() async {
    try {
      final price = await _perpsMarket.getPrice(PerpsMarket.BTC_MARKET_ID);
      return price.toDouble() / 1e18;
    } catch (e) {
      throw Exception('Failed to fetch BTC price: $e');
    }
  }

  /// Fetches only the current funding rate for BTC.
  Future<double> getBtcFundingRate() async {
    try {
      final fundingRate =
          await _perpsMarket.getFundingRate(PerpsMarket.BTC_MARKET_ID);
      return (fundingRate.toDouble() / 1e18) * 100; // Convert to percentage
    } catch (e) {
      throw Exception('Failed to fetch BTC funding rate: $e');
    }
  }

  /// Fetches user's open orders with pagination
  /// [offset] - Starting index for pagination
  /// [limit] - Maximum number of orders to return (default 25)
  Future<List<Map<String, dynamic>>> getOpenOrders({
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      // TODO: Query from Synthetix subgraph or contract events
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      throw Exception('Failed to fetch open orders: $e');
    }
  }

  /// Fetches user's order history with pagination
  /// [offset] - Starting index for pagination
  /// [limit] - Maximum number of orders to return (default 25)
  Future<List<Map<String, dynamic>>> getOrderHistory({
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      // TODO: Query from Synthetix subgraph with pagination
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      throw Exception('Failed to fetch order history: $e');
    }
  }

  /// Fetches user's trade history with pagination
  /// [offset] - Starting index for pagination
  /// [limit] - Maximum number of trades to return (default 25)
  Future<List<Map<String, dynamic>>> getTradeHistory({
    int offset = 0,
    int limit = 25,
  }) async {
    try {
      // TODO: Query from Synthetix subgraph with pagination
      // For now, return empty list as placeholder
      return [];
    } catch (e) {
      throw Exception('Failed to fetch trade history: $e');
    }
  }

  /// Fetches market metrics (skew, open interest, funding rate)
  Future<Map<String, double>> getMarketMetrics(String symbol) async {
    try {
      // TODO: Fetch from Synthetix subgraph or contract
      // For now, return placeholder metrics
      return {
        'skew': 0.0,
        'openInterest': 0.0,
        'fundingRate': 0.0,
      };
    } catch (e) {
      throw Exception('Failed to fetch market metrics: $e');
    }
  }

  /// Fetches user's available margin for trading
  Future<double> getAvailableMargin() async {
    try {
      // TODO: Query from user's perps account
      return 0.0;
    } catch (e) {
      throw Exception('Failed to fetch available margin: $e');
    }
  }
}
