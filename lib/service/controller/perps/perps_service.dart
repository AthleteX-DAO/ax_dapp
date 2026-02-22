import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/web3dart.dart';

/// Service for interacting with Synthetix V3 Perps contracts.
/// Configurable per-chain via [SynthetixConfig].
class PerpsService {
  PerpsService({
    required Web3Client web3Client,
    required WalletRepository walletRepository,
  })  : _web3Client = web3Client,
        _walletRepository = walletRepository;

  final Web3Client _web3Client;
  final WalletRepository _walletRepository;

  // Contract address from SynthetixConfig
  static const String _perpsMarketProxyAddress = SynthetixConfig.perpsMarketProxy;
  
  // Market IDs — TODO: configure perps markets on Eth Sepolia deployment
  // These IDs were from the Arb Sepolia omnibus and need to be updated
  // once perps TOML is deployed on Eth Sepolia
  static const Map<String, int> _marketIds = {
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

  /// Places a perps order via Synthetix V3
  /// 
  /// [symbol] - The market symbol (e.g., 'BTC', 'ETH')
  /// [sizeDelta] - The size change (positive for long, negative for short) in USD
  /// [isMarketOrder] - Whether this is a market order (true) or limit order (false)
  /// [limitPrice] - The limit price for limit orders (optional)
  Future<String> placeOrder({
    required String symbol,
    required double sizeDelta,
    required bool isMarketOrder,
    double? limitPrice,
  }) async {
    try {
      final walletCreds = _walletRepository.credentials;
      final credentials = walletCreds.value;

      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // Convert size to wei (18 decimals)
      final sizeDeltaWei = BigInt.from((sizeDelta * 1e18).toInt());
      
      // Get the perps market contract
      final perpsContract = DeployedContract(
        ContractAbi.fromJson(_perpsMarketAbi, 'PerpsMarketProxy'),
        EthereumAddress.fromHex(_perpsMarketProxyAddress),
      );

      if (isMarketOrder) {
        // For market orders, use commitOrder function
        final commitOrderFunction = perpsContract.function('commitOrder');
        
        // Prepare order commitment
        final accountId = await _getOrCreatePerpsAccount();
        
        final transaction = Transaction.callContract(
          contract: perpsContract,
          function: commitOrderFunction,
          parameters: [
            BigInt.from(accountId),
            BigInt.from(marketId),
            sizeDeltaWei,
          ],
        );

        final txHash = await _web3Client.sendTransaction(
          credentials,
          transaction,
          chainId: SynthetixConfig.chainId,
        );

        return txHash;
      } else {
        // For limit orders, use different function
        throw UnimplementedError('Limit orders not yet implemented');
      }
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }

  /// Gets or creates a perps account for the current user
  Future<int> _getOrCreatePerpsAccount() async {
    // Check if account exists, otherwise create one
    // For now, return a default account ID
    // TODO: Implement proper account management
    return 1337; // Placeholder account ID
  }

  /// Gets the account balance and margin info
  Future<Map<String, double>> getAccountBalance() async {
    // TODO: Implement actual balance fetching from contract
    return {
      'availableMargin': 0.0,
      'accountValue': 0.0,
    };
  }

  /// Gets the current market skew (net position imbalance)
  /// Returns skew in USD, positive = more longs, negative = more shorts
  Future<double> getMarketSkew(String symbol) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from Synthetix subgraph or contract
      // For now, return placeholder
      return 0.0;
    } catch (e) {
      print('Error getting market skew: $e');
      return 0.0;
    }
  }

  /// Gets the total open interest for a market
  Future<double> getOpenInterest(String symbol) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from Synthetix subgraph or contract
      // For now, return placeholder
      return 0.0;
    } catch (e) {
      print('Error getting open interest: $e');
      return 0.0;
    }
  }

  /// Gets the user's available margin for trading
  Future<double> getUserAvailableMargin() async {
    try {
      // TODO: Fetch from user's perps account
      return 0.0;
    } catch (e) {
      print('Error getting available margin: $e');
      return 0.0;
    }
  }

  /// Calculates the fill price for a trade of given size
  /// Uses Synthetix skew-based pricing formula:
  /// fillPrice = price × ((1 + pd_before) + (1 + pd_after)) / 2
  /// where pd = skew / skewScale
  Future<double> calculateFillPrice({
    required String symbol,
    required double size,
    required bool isLong,
    required double currentPrice,
  }) async {
    try {
      final skew = await getMarketSkew(symbol);
      const skewScale = 1000000.0; // Default Synthetix skew scale

      final direction = isLong ? 1.0 : -1.0;

      // Premium/discount before trade
      final pdBefore = skew / skewScale;

      // Premium/discount after trade
      final skewAfter = skew + (direction * size);
      final pdAfter = skewAfter / skewScale;

      // Average fill price
      final fillPrice =
          currentPrice * ((1 + pdBefore) + (1 + pdAfter)) / 2;

      return fillPrice;
    } catch (e) {
      print('Error calculating fill price: $e');
      return 0.0;
    }
  }

  /// Gets the current funding rate for a market
  /// Returns as decimal (e.g., 0.0001 for 0.01%)
  Future<double> getMarketFundingRate(String symbol) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from Synthetix subgraph or contract
      // For now, return placeholder
      return 0.0;
    } catch (e) {
      print('Error getting funding rate: $e');
      return 0.0;
    }
  }

  /// Gets user's open positions
  /// Returns list of position maps with size, side, entryPrice, etc.
  Future<List<Map<String, dynamic>>> getUserPositions(String symbol) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from contract or subgraph
      return [];
    } catch (e) {
      print('Error getting user positions: $e');
      return [];
    }
  }

  /// Gets user's open orders
  /// Returns list of order maps with size, price, status, etc.
  Future<List<Map<String, dynamic>>> getUserOpenOrders(String symbol) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from subgraph
      return [];
    } catch (e) {
      print('Error getting open orders: $e');
      return [];
    }
  }

  /// Gets user's order history with pagination
  Future<List<Map<String, dynamic>>> getUserOrderHistory({
    required String symbol,
    required int offset,
    required int limit,
  }) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from subgraph with pagination
      return [];
    } catch (e) {
      print('Error getting order history: $e');
      return [];
    }
  }

  /// Gets user's trade history with pagination
  Future<List<Map<String, dynamic>>> getUserTradeHistory({
    required String symbol,
    required int offset,
    required int limit,
  }) async {
    try {
      final marketId = _marketIds[symbol];
      if (marketId == null) {
        throw Exception('Market not found for symbol: $symbol');
      }

      // TODO: Query from subgraph with pagination
      return [];
    } catch (e) {
      print('Error getting trade history: $e');
      return [];
    }
  }

  /// Simplified ABI for PerpsMarketProxy (only the functions we need)
  static const String _perpsMarketAbi = '''
  [
    {
      "inputs": [
        {"name": "accountId", "type": "uint128"},
        {"name": "marketId", "type": "uint128"},
        {"name": "sizeDelta", "type": "int128"}
      ],
      "name": "commitOrder",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {"name": "accountId", "type": "uint128"}
      ],
      "name": "getAvailableMargin",
      "outputs": [
        {"name": "availableMargin", "type": "int256"}
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {"name": "accountId", "type": "uint128"}
      ],
      "name": "totalAccountValue",
      "outputs": [
        {"name": "totalAccountValue", "type": "int256"}
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
  ''';
}
