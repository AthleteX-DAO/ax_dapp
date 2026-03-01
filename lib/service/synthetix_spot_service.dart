import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:web3dart/json_rpc.dart' show RPCError;
import 'package:web3dart/web3dart.dart';

/// Service for interacting with Synthetix V3 Spot Markets
class SynthetixSpotService {

  SynthetixSpotService() {
    _client = Web3Client(SynthetixConfig.rpcUrl, http.Client());
    _initContracts();
  }
  late Web3Client _client;
  late DeployedContract _spotMarket;

  void _initContracts() {
    final spotAbi = ContractAbi.fromJson('''
    [
      {
        "inputs": [{"internalType": "uint128", "name": "synthMarketId", "type": "uint128"}],
        "name": "getSynth",
        "outputs": [{"internalType": "address", "name": "", "type": "address"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "synthMarketId", "type": "uint128"},
          {"internalType": "uint256", "name": "synthAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "minUsdAmount", "type": "uint256"},
          {"internalType": "address", "name": "referrer", "type": "address"}
        ],
        "name": "sell",
        "outputs": [
          {"internalType": "uint256", "name": "usdAmountReceived", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "synthMarketId", "type": "uint128"},
          {"internalType": "uint256", "name": "usdAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "minAmountReceived", "type": "uint256"},
          {"internalType": "address", "name": "referrer", "type": "address"}
        ],
        "name": "buy",
        "outputs": [
          {"internalType": "uint256", "name": "synthAmount", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "marketId", "type": "uint128"},
          {"internalType": "uint256", "name": "usdAmount", "type": "uint256"}
        ],
        "name": "quoteBuyExactIn",
        "outputs": [
          {"internalType": "uint256", "name": "synthAmount", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "marketId", "type": "uint128"},
          {"internalType": "uint256", "name": "synthAmount", "type": "uint256"}
        ],
        "name": "quoteSellExactIn",
        "outputs": [
          {"internalType": "uint256", "name": "returnAmount", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "marketId", "type": "uint128"},
          {"internalType": "uint256", "name": "wrapAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "minAmountReceived", "type": "uint256"}
        ],
        "name": "wrap",
        "outputs": [
          {"internalType": "uint256", "name": "amountToMint", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "marketId", "type": "uint128"},
          {"internalType": "uint256", "name": "unwrapAmount", "type": "uint256"},
          {"internalType": "uint256", "name": "minAmountReceived", "type": "uint256"}
        ],
        "name": "unwrap",
        "outputs": [
          {"internalType": "uint256", "name": "returnCollateralAmount", "type": "uint256"},
          {"components": [{"internalType": "uint256", "name": "fixedFees", "type": "uint256"},{"internalType": "uint256", "name": "utilizationFees", "type": "uint256"},{"internalType": "int256", "name": "skewFees", "type": "int256"},{"internalType": "int256", "name": "wrapperFees", "type": "int256"}], "internalType": "struct OrderFees.Data", "name": "fees", "type": "tuple"}
        ],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ]
    ''', 'SpotMarketProxy',);

    _spotMarket = DeployedContract(
      spotAbi,
      EthereumAddress.fromHex(SynthetixConfig.spotMarketProxy),
    );
  }

  /// Get synth token address for a market
  Future<String?> getSynthAddress(int marketId) async {
    try {
      final result = await _client.call(
        contract: _spotMarket,
        function: _spotMarket.function('getSynth'),
        params: [BigInt.from(marketId)],
      );
      return (result[0] as EthereumAddress).hex;
    } catch (e) {
      print('Error getting synth address: $e');
      return null;
    }
  }

  /// Get quote for buying synths with USD
  Future<Map<String, dynamic>> quoteBuy(int marketId, BigInt usdAmount) async {
    try {
      final result = await _client.call(
        contract: _spotMarket,
        function: _spotMarket.function('quoteBuyExactIn'),
        params: [BigInt.from(marketId), usdAmount],
      );
      return {
        'synthAmount': result[0] as BigInt,
        'fees': result[1],
      };
    } catch (e) {
      print('Error getting buy quote: $e');
      return {'synthAmount': BigInt.zero, 'fees': null};
    }
  }

  /// Get quote for selling synths for USD
  Future<Map<String, dynamic>> quoteSell(
      int marketId, BigInt synthAmount,) async {
    try {
      final result = await _client.call(
        contract: _spotMarket,
        function: _spotMarket.function('quoteSellExactIn'),
        params: [BigInt.from(marketId), synthAmount],
      );
      return {
        'usdAmount': result[0] as BigInt,
        'fees': result[1],
      };
    } catch (e) {
      print('Error getting sell quote: $e');
      return {'usdAmount': BigInt.zero, 'fees': null};
    }
  }

  /// Buy synths with USD (atomic swap)
  Future<String> buySynth({
    required int marketId,
    required BigInt usdAmount,
    required BigInt minSynthAmount,
    required Credentials credentials,
    String? referrer,
  }) async {
    if (usdAmount <= BigInt.zero) {
      throw ArgumentError.value(usdAmount, 'usdAmount', 'Buy amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('buy'),
      parameters: [
        BigInt.from(marketId),
        usdAmount,
        minSynthAmount,
        EthereumAddressValidator.parseOrFallback(referrer),
      ],
    );

    try {
      final txHash = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: SynthetixConfig.chainId,
      );
      if (txHash.isEmpty) throw Exception('Buy synth returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      throw Exception('Spot market buy reverted: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Sell synths for USD (atomic swap)
  Future<String> sellSynth({
    required int marketId,
    required BigInt synthAmount,
    required BigInt minUsdAmount,
    required Credentials credentials,
    String? referrer,
  }) async {
    if (synthAmount <= BigInt.zero) {
      throw ArgumentError.value(synthAmount, 'synthAmount', 'Sell amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('sell'),
      parameters: [
        BigInt.from(marketId),
        synthAmount,
        minUsdAmount,
        EthereumAddressValidator.parseOrFallback(referrer),
      ],
    );

    try {
      final txHash = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: SynthetixConfig.chainId,
      );
      if (txHash.isEmpty) throw Exception('Sell synth returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      throw Exception('Spot market sell reverted: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Wrap real collateral (e.g. USDC) into its synth equivalent (e.g. axUSDC).
  ///
  /// Requires the caller to have ERC-20 approved [wrapAmount] to SpotMarketProxy
  /// before calling this. [minAmountReceived] protects against slippage.
  Future<String> wrapCollateral({
    required int marketId,
    required BigInt wrapAmount,
    required BigInt minAmountReceived,
    required Credentials credentials,
  }) async {
    if (wrapAmount <= BigInt.zero) {
      throw ArgumentError.value(wrapAmount, 'wrapAmount', 'Wrap amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('wrap'),
      parameters: [
        BigInt.from(marketId),
        wrapAmount,
        minAmountReceived,
      ],
    );
    try {
      final txHash = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: SynthetixConfig.chainId,
      );
      if (txHash.isEmpty) throw Exception('Wrap collateral returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      throw Exception('Wrap collateral reverted: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Unwrap synth back to the underlying collateral.
  Future<String> unwrapCollateral({
    required int marketId,
    required BigInt unwrapAmount,
    required BigInt minAmountReceived,
    required Credentials credentials,
  }) async {
    if (unwrapAmount <= BigInt.zero) {
      throw ArgumentError.value(unwrapAmount, 'unwrapAmount', 'Unwrap amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('unwrap'),
      parameters: [
        BigInt.from(marketId),
        unwrapAmount,
        minAmountReceived,
      ],
    );
    try {
      final txHash = await _client.sendTransaction(
        credentials,
        transaction,
        chainId: SynthetixConfig.chainId,
      );
      if (txHash.isEmpty) throw Exception('Unwrap collateral returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      throw Exception('Unwrap collateral reverted: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _client.dispose();
  }
}
