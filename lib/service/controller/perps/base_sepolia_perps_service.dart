import 'package:web3dart/web3dart.dart';
import 'package:wallet_repository/wallet_repository.dart';

/// Service for interacting with Synthetix V3 Perps contracts on Base Sepolia
class BaseSepoliaPerpsService {
  BaseSepoliaPerpsService({
    required Web3Client web3Client,
    required WalletRepository walletRepository,
  })  : _web3Client = web3Client,
        _walletRepository = walletRepository;

  final Web3Client _web3Client;
  final WalletRepository _walletRepository;

  // Base Sepolia Contract Addresses
  static const String _perpsMarketProxyAddress = '0xf53Ca60F031FAf0E347D44FbaA4870da68250c8d';
  
  // Market IDs for different assets (from Synthetix V3)
  static const Map<String, int> _marketIds = {
    'BTC': 100,
    'ETH': 200,
    'SOL': 300,
    'BNB': 400,
    'XRP': 500,
    'DOGE': 600,
    'ADA': 700,
  };

  /// Places a perps order on Base Sepolia
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
          chainId: 84532, // Base Sepolia chain ID
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
