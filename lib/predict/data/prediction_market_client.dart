import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

/// Data-layer client for reading/writing AthleteXPredictionMarket contract
/// state on Polygon mainnet.
///
/// NO business logic — raw contract calls only (Data Layer).
class PredictionMarketClient {
  PredictionMarketClient({
    Web3Client? web3Client,
    String rpcUrl = 'https://polygon-rpc.com',
  }) : _client = web3Client ?? Web3Client(rpcUrl, Client());

  final Web3Client _client;

  // ─── Minimal ABI fragments ────────────────────────────────────────────

  static final _marketAbi = ContractAbi.fromJson(
    '''[
      {"inputs":[],"name":"priceRequested","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"marketResolved","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"settlementPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"longToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"shortToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"collateralToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"pairName","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"protocolFeeRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"requestTimestamp","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"optimisticOracleLivenessTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[{"internalType":"uint256","name":"tokensToCreate","type":"uint256"}],"name":"create","outputs":[],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[{"internalType":"uint256","name":"tokensToRedeem","type":"uint256"}],"name":"redeem","outputs":[],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[{"internalType":"uint256","name":"longTokensToRedeem","type":"uint256"},{"internalType":"uint256","name":"shortTokensToRedeem","type":"uint256"}],"name":"settle","outputs":[{"internalType":"uint256","name":"collateralReturned","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[],"name":"resolveMarket","outputs":[],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[],"name":"initializeMarket","outputs":[],"stateMutability":"nonpayable","type":"function"}
    ]''',
    'AthleteXPredictionMarket',
  );

  static final _erc20Abi = ContractAbi.fromJson(
    '''[
      {"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},
      {"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},
      {"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},
      {"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}
    ]''',
    'ERC20',
  );

  // ─── View helpers ─────────────────────────────────────────────────────

  DeployedContract _marketContract(String address) =>
      DeployedContract(_marketAbi, EthereumAddress.fromHex(address));

  DeployedContract _erc20Contract(String address) =>
      DeployedContract(_erc20Abi, EthereumAddress.fromHex(address));

  Future<List<dynamic>> _call(
    DeployedContract contract,
    String functionName, [
    List<dynamic> params = const [],
  ]) async {
    return _client.call(
      contract: contract,
      function: contract.function(functionName),
      params: params,
    );
  }

  // ─── Market read functions ────────────────────────────────────────────

  /// Whether the market has been initialized (initializeMarket was called).
  Future<bool> isPriceRequested(String marketAddress) async {
    final result = await _call(_marketContract(marketAddress), 'priceRequested');
    return result[0] as bool;
  }

  /// Whether the market has been resolved (resolveMarket was called
  /// successfully).
  Future<bool> isMarketResolved(String marketAddress) async {
    final result =
        await _call(_marketContract(marketAddress), 'marketResolved');
    return result[0] as bool;
  }

  /// The settlement price (0 = NO, 5e17 = draw, 1e18 = YES).
  /// Only meaningful after market is resolved.
  Future<BigInt> getSettlementPrice(String marketAddress) async {
    final result =
        await _call(_marketContract(marketAddress), 'settlementPrice');
    return result[0] as BigInt;
  }

  /// The protocol fee rate as a D18 value (e.g. 1e16 = 1%).
  Future<BigInt> getProtocolFeeRate(String marketAddress) async {
    final result =
        await _call(_marketContract(marketAddress), 'protocolFeeRate');
    return result[0] as BigInt;
  }

  /// The request timestamp (when market was created).
  Future<BigInt> getRequestTimestamp(String marketAddress) async {
    final result =
        await _call(_marketContract(marketAddress), 'requestTimestamp');
    return result[0] as BigInt;
  }

  /// Liveness time in seconds.
  Future<BigInt> getLivenessTime(String marketAddress) async {
    final result = await _call(
      _marketContract(marketAddress),
      'optimisticOracleLivenessTime',
    );
    return result[0] as BigInt;
  }

  // ─── ERC-20 read functions ────────────────────────────────────────────

  /// Get total supply of a YES or NO token.
  Future<BigInt> totalSupply(String tokenAddress) async {
    final result = await _call(_erc20Contract(tokenAddress), 'totalSupply');
    return result[0] as BigInt;
  }

  /// Get balance of a YES or NO token for a given wallet address.
  Future<BigInt> balanceOf(String tokenAddress, String walletAddress) async {
    final result = await _call(
      _erc20Contract(tokenAddress),
      'balanceOf',
      [EthereumAddress.fromHex(walletAddress)],
    );
    return result[0] as BigInt;
  }

  /// Get axUSD balance for a wallet.
  Future<BigInt> axUsdBalance(String axUsdAddress, String wallet) async {
    return balanceOf(axUsdAddress, wallet);
  }

  /// Get current allowance of axUSD for a spender.
  Future<BigInt> allowance(
    String tokenAddress,
    String ownerAddress,
    String spenderAddress,
  ) async {
    final result = await _call(
      _erc20Contract(tokenAddress),
      'allowance',
      [
        EthereumAddress.fromHex(ownerAddress),
        EthereumAddress.fromHex(spenderAddress),
      ],
    );
    return result[0] as BigInt;
  }

  // ─── Derived market data ──────────────────────────────────────────────

  /// Fetches on-chain state for a single market and returns a summary.
  Future<MarketOnChainData> getMarketData(
    String marketAddress,
    String yesTokenAddress,
    String noTokenAddress,
  ) async {
    try {
      final results = await Future.wait([
        isPriceRequested(marketAddress),
        isMarketResolved(marketAddress),
        getSettlementPrice(marketAddress),
        totalSupply(yesTokenAddress),
        totalSupply(noTokenAddress),
      ]);

      final priceRequested = (results[0] as bool?) ?? false;
      final resolved = (results[1] as bool?) ?? false;
      final settlement = (results[2] as BigInt?) ?? BigInt.zero;
      final yesSupply = (results[3] as BigInt?) ?? BigInt.zero;
      final noSupply = (results[4] as BigInt?) ?? BigInt.zero;

      // Calculate implied probabilities from token supply ratios.
      // YES price = NO supply / total supply (what you could redeem if outcome is YES)
      // NO price = YES supply / total supply (what you could redeem if outcome is NO)
      final totalTokens = yesSupply + noSupply;
      double yesPrice;
      double noPrice;
      if (totalTokens == BigInt.zero) {
        // No positions yet — default to 50/50
        yesPrice = 0.50;
        noPrice = 0.50;
      } else {
        // Supply-ratio pricing: price reflects the complementary supply
        yesPrice = noSupply.toDouble() / totalTokens.toDouble();
        noPrice = yesSupply.toDouble() / totalTokens.toDouble();
      }

      // Volume proxy: total YES supply × 2 (each create() mints YES+NO pair)
      final volumeWei = yesSupply;
      final volume = volumeWei.toDouble() / pow(10, 18);

      return MarketOnChainData(
        isInitialized: priceRequested,
        isResolved: resolved,
        settlementPrice: settlement,
        yesTokenSupply: yesSupply,
        noTokenSupply: noSupply,
        yesPrice: yesPrice,
        noPrice: noPrice,
        tradingVolume: volume,
      );
    } catch (e) {
      debugPrint('Error reading market $marketAddress: $e');
      // Return defaults so the UI still renders
      return MarketOnChainData.empty();
    }
  }

  // ─── Write functions ──────────────────────────────────────────────────

  /// Approve axUSD spend by a market contract.
  Future<String> approveAxUsd({
    required String axUsdAddress,
    required String spenderAddress,
    required BigInt amount,
    required Credentials credentials,
    int chainId = 137,
  }) async {
    final contract = _erc20Contract(axUsdAddress);
    final function = contract.function('approve');
    return _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [EthereumAddress.fromHex(spenderAddress), amount],
      ),
      chainId: chainId,
    );
  }

  /// Create YES/NO tokens by depositing axUSD collateral.
  /// Caller must have approved the market contract to spend axUSD first.
  Future<String> createTokens({
    required String marketAddress,
    required BigInt tokensToCreate,
    required Credentials credentials,
    int chainId = 137,
  }) async {
    final contract = _marketContract(marketAddress);
    final function = contract.function('create');
    return _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [tokensToCreate],
      ),
      chainId: chainId,
    );
  }

  /// Redeem equal pairs of YES+NO tokens for axUSD collateral.
  Future<String> redeemTokens({
    required String marketAddress,
    required BigInt tokensToRedeem,
    required Credentials credentials,
    int chainId = 137,
  }) async {
    final contract = _marketContract(marketAddress);
    final function = contract.function('redeem');
    return _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [tokensToRedeem],
      ),
      chainId: chainId,
    );
  }

  /// Settle YES/NO tokens for axUSD after the market has resolved.
  Future<String> settleTokens({
    required String marketAddress,
    required BigInt longTokensToRedeem,
    required BigInt shortTokensToRedeem,
    required Credentials credentials,
    int chainId = 137,
  }) async {
    final contract = _marketContract(marketAddress);
    final function = contract.function('settle');
    return _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [longTokensToRedeem, shortTokensToRedeem],
      ),
      chainId: chainId,
    );
  }

  /// Call resolveMarket() — pulls settled price from IOO.
  Future<String> resolveMarket({
    required String marketAddress,
    required Credentials credentials,
    int chainId = 137,
  }) async {
    final contract = _marketContract(marketAddress);
    final function = contract.function('resolveMarket');
    return _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [],
      ),
      chainId: chainId,
    );
  }
}

/// Snapshot of on-chain state for a single prediction market.
class MarketOnChainData {
  const MarketOnChainData({
    required this.isInitialized,
    required this.isResolved,
    required this.settlementPrice,
    required this.yesTokenSupply,
    required this.noTokenSupply,
    required this.yesPrice,
    required this.noPrice,
    required this.tradingVolume,
  });

  factory MarketOnChainData.empty() => MarketOnChainData(
        isInitialized: false,
        isResolved: false,
        settlementPrice: BigInt.zero,
        yesTokenSupply: BigInt.zero,
        noTokenSupply: BigInt.zero,
        yesPrice: 0.50,
        noPrice: 0.50,
        tradingVolume: 0,
      );

  final bool isInitialized;
  final bool isResolved;
  final BigInt settlementPrice;
  final BigInt yesTokenSupply;
  final BigInt noTokenSupply;
  final double yesPrice;
  final double noPrice;
  final double tradingVolume;
}
