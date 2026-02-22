import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

/// Service for interacting with Synthetix V3 Perps Markets
class SynthetixPerpsService {

  SynthetixPerpsService() {
    _client = Web3Client(SynthetixConfig.rpcUrl, http.Client());
    _initContracts();
  }
  late Web3Client _client;
  late DeployedContract _perpsMarket;

  void _initContracts() {
    final perpsAbi = ContractAbi.fromJson('''
    [
      {
        "inputs": [{"internalType": "uint128", "name": "requestedAccountId", "type": "uint128"}],
        "name": "createAccount",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [{"internalType": "address", "name": "user", "type": "address"}],
        "name": "getAccountPermissions",
        "outputs": [{"internalType": "uint128[]", "name": "", "type": "uint128[]"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "marketId", "type": "uint128"}
        ],
        "name": "getOpenPosition",
        "outputs": [
          {"internalType": "int256", "name": "totalPnl", "type": "int256"},
          {"internalType": "int256", "name": "accruedFunding", "type": "int256"},
          {"internalType": "int128", "name": "positionSize", "type": "int128"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "synthMarketId", "type": "uint128"},
          {"internalType": "int256", "name": "amountDelta", "type": "int256"}
        ],
        "name": "modifyCollateral",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"}
        ],
        "name": "getAvailableMargin",
        "outputs": [{"internalType": "int256", "name": "", "type": "int256"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "marketId", "type": "uint128"}
        ],
        "name": "metadata",
        "outputs": [
          {"internalType": "string", "name": "name", "type": "string"},
          {"internalType": "string", "name": "symbol", "type": "string"}
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''', 'PerpsMarketProxy',);

    _perpsMarket = DeployedContract(
      perpsAbi,
      EthereumAddress.fromHex(SynthetixConfig.perpsMarketProxy),
    );
  }

  /// Get user's perps account IDs
  Future<List<BigInt>> getUserAccounts(String userAddress) async {
    try {
      final result = await _client.call(
        contract: _perpsMarket,
        function: _perpsMarket.function('getAccountPermissions'),
        params: [EthereumAddress.fromHex(userAddress)],
      );
      return (result[0] as List).cast<BigInt>();
    } catch (e) {
      print('Error getting perps accounts: $e');
      return [];
    }
  }

  /// Get open position for an account in a market
  Future<Map<String, dynamic>> getOpenPosition(
    int accountId,
    int marketId,
  ) async {
    try {
      final result = await _client.call(
        contract: _perpsMarket,
        function: _perpsMarket.function('getOpenPosition'),
        params: [BigInt.from(accountId), BigInt.from(marketId)],
      );
      return {
        'totalPnl': result[0] as BigInt,
        'accruedFunding': result[1] as BigInt,
        'positionSize': result[2] as BigInt,
      };
    } catch (e) {
      print('Error getting open position: $e');
      return {
        'totalPnl': BigInt.zero,
        'accruedFunding': BigInt.zero,
        'positionSize': BigInt.zero,
      };
    }
  }

  /// Get available margin for an account
  Future<BigInt> getAvailableMargin(int accountId) async {
    try {
      final result = await _client.call(
        contract: _perpsMarket,
        function: _perpsMarket.function('getAvailableMargin'),
        params: [BigInt.from(accountId)],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting available margin: $e');
      return BigInt.zero;
    }
  }

  /// Get market metadata (name, symbol)
  Future<Map<String, String>> getMarketMetadata(int marketId) async {
    try {
      final result = await _client.call(
        contract: _perpsMarket,
        function: _perpsMarket.function('metadata'),
        params: [BigInt.from(marketId)],
      );
      return {
        'name': result[0] as String,
        'symbol': result[1] as String,
      };
    } catch (e) {
      print('Error getting market metadata: $e');
      return {'name': '', 'symbol': ''};
    }
  }

  /// Create a new perps account
  Future<String> createAccount(
    int accountId,
    Credentials credentials,
  ) async {
    final transaction = Transaction.callContract(
      contract: _perpsMarket,
      function: _perpsMarket.function('createAccount'),
      parameters: [BigInt.from(accountId)],
    );

    return _client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  /// Modify collateral (deposit or withdraw)
  Future<String> modifyCollateral({
    required int accountId,
    required int synthMarketId,
    required BigInt amountDelta, // positive = deposit, negative = withdraw
    required Credentials credentials,
  }) async {
    final transaction = Transaction.callContract(
      contract: _perpsMarket,
      function: _perpsMarket.function('modifyCollateral'),
      parameters: [
        BigInt.from(accountId),
        BigInt.from(synthMarketId),
        amountDelta,
      ],
    );

    return _client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  void dispose() {
    _client.dispose();
  }
}
