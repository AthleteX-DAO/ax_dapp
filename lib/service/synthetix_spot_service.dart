import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:http/http.dart' as http;
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
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('buy'),
      parameters: [
        BigInt.from(marketId),
        usdAmount,
        minSynthAmount,
        EthereumAddress.fromHex(
            referrer ?? '0x0000000000000000000000000000000000000000',),
      ],
    );

    return _client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  /// Sell synths for USD (atomic swap)
  Future<String> sellSynth({
    required int marketId,
    required BigInt synthAmount,
    required BigInt minUsdAmount,
    required Credentials credentials,
    String? referrer,
  }) async {
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('sell'),
      parameters: [
        BigInt.from(marketId),
        synthAmount,
        minUsdAmount,
        EthereumAddress.fromHex(
            referrer ?? '0x0000000000000000000000000000000000000000',),
      ],
    );

    return _client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
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
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('wrap'),
      parameters: [
        BigInt.from(marketId),
        wrapAmount,
        minAmountReceived,
      ],
    );
    return _client.sendTransaction(
      credentials,
      transaction,
      chainId: SynthetixConfig.chainId,
    );
  }

  /// Unwrap synth back to the underlying collateral.
  Future<String> unwrapCollateral({
    required int marketId,
    required BigInt unwrapAmount,
    required BigInt minAmountReceived,
    required Credentials credentials,
  }) async {
    final transaction = Transaction.callContract(
      contract: _spotMarket,
      function: _spotMarket.function('unwrap'),
      parameters: [
        BigInt.from(marketId),
        unwrapAmount,
        minAmountReceived,
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
