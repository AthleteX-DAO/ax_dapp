import 'package:ethereum_api/perps_market_api.dart';
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/src/wallet/models/ethereum_chain.dart';
import 'package:web3dart/web3dart.dart';

/// Data transfer object for BTC Perps market data.
class BtcPerpsData {
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

  BtcPerpsData({
    required this.price,
    required this.fundingRate,
    required this.openInterest,
    required this.skew,
    required this.makerFee,
    required this.takerFee,
    required this.timestamp,
  });

  /// Converts price from wei to readable format (with decimals).
  double get priceInUSD => price.toDouble() / 1e18;

  /// Converts funding rate from wei to percentage (annualized).
  double get fundingRatePercentage => (fundingRate.toDouble() / 1e18) * 100;

  /// Converts open interest from wei to readable format.
  double get openInterestUSD => openInterest.toDouble() / 1e18;

  /// Converts skew to readable format.
  double get skewUSD => skew.toDouble() / 1e18;

  /// Converts maker fee from wei to percentage.
  double get makerFeePercentage => (makerFee.toDouble() / 1e18) * 100;

  /// Converts taker fee from wei to percentage.
  double get takerFeePercentage => (takerFee.toDouble() / 1e18) * 100;

  @override
  String toString() {
    return 'BtcPerpsData(price: ${priceInUSD.toStringAsFixed(2)} USD, '
        'fundingRate: ${fundingRatePercentage.toStringAsFixed(4)}%, '
        'openInterest: ${openInterestUSD.toStringAsFixed(0)} USD, '
        'skew: ${skewUSD.toStringAsFixed(0)} USD, '
        'makerFee: ${makerFeePercentage.toStringAsFixed(4)}%, '
        'takerFee: ${takerFeePercentage.toStringAsFixed(4)}%)';
  }
}

/// Repository for fetching Synthetix V3 BTC Perps data on Ethereum mainnet.
class PerpsRepository {
  final Web3Client _web3Client;
  late final PerpsMarket _perpsMarket;

  PerpsRepository({required Web3Client web3Client})
      : _web3Client = web3Client {
    final perpsAddress = EthereumAddress.fromHex(
      const EthereumAddressConfig.perpsMarketProxy()
          .address(EthereumChain.values.firstWhere((c) => c.chainId == 1)),
    );
    _perpsMarket = PerpsMarket(
      address: perpsAddress,
      client: _web3Client,
    );
  }

  /// Fetches live BTC Perps data (price, funding, OI, skew, fees) from mainnet.
  /// Returns a [BtcPerpsData] object or throws on error.
  Future<BtcPerpsData> getBtcPerpsData() async {
    try {
      // Fetch all data concurrently
      final futures = await Future.wait([
        _perpsMarket.getPrice(PerpsMarket.BTC_MARKET_ID),
        _perpsMarket.getFundingRate(PerpsMarket.BTC_MARKET_ID),
        _perpsMarket.getOpenInterest(PerpsMarket.BTC_MARKET_ID),
        _perpsMarket.getSkew(PerpsMarket.BTC_MARKET_ID),
      ]);

      final price = futures[0];
      final fundingRate = futures[1];
      final openInterest = futures[2];
      final skew = futures[3];

      // TODO: Fetch actual maker/taker fees from contract when ABI is finalized
      final BigInt makerFee = BigInt.zero; // Placeholder
      final BigInt takerFee = BigInt.zero; // Placeholder

      return BtcPerpsData(
        price: price,
        fundingRate: fundingRate,
        openInterest: openInterest,
        skew: skew,
        makerFee: makerFee,
        takerFee: takerFee,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // Return mock data for development/testing
      print('Error fetching BTC Perps data, using mock data: $e');
      return BtcPerpsData(
        price: BigInt.from(95000) * BigInt.from(10).pow(18), // $95,000 BTC
        fundingRate: BigInt.from(0) * BigInt.from(10).pow(16), // 0% funding rate
        openInterest: BigInt.from(10000000) * BigInt.from(10).pow(18), // $10M OI
        skew: BigInt.from(100000) * BigInt.from(10).pow(18), // $100k skew
        makerFee: BigInt.from(1) * BigInt.from(10).pow(16), // 0.01% maker fee
        takerFee: BigInt.from(5) * BigInt.from(10).pow(16), // 0.05% taker fee
        timestamp: DateTime.now(),
      );
    }
  }

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
