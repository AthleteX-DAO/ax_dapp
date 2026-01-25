import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

/// Repository for interacting with Synthetix v3 Spot Markets on Base Sepolia
class SynthetixSpotRepository {
  late Web3Client _web3Client;
  final String rpcUrl;
  final String spotMarketProxyAddress;
  final String coreProxyAddress;
  final String oracleManagerAddress;

  late DeployedContract spotMarketContract;
  late DeployedContract oracleManagerContract;
  late ContractAbi erc20Abi;

  SynthetixSpotRepository({
    required this.rpcUrl,
    required this.spotMarketProxyAddress,
    required this.coreProxyAddress,
    required this.oracleManagerAddress,
  });

  Future<void> initialize() async {
    _web3Client = Web3Client(rpcUrl, http.Client());
    
    // Load ABIs
    final spotMarketAbiJson = await rootBundle.loadString(
      'lib/spot_markets/abi/spot_market_proxy_abi.json',
    );
    final oracleManagerAbiJson = await rootBundle.loadString(
      'lib/spot_markets/abi/oracle_manager_abi.json',
    );
    final erc20AbiJson = await rootBundle.loadString(
      'lib/spot_markets/abi/erc20_abi.json',
    );

    final spotMarketAbi = ContractAbi.fromJson(spotMarketAbiJson, 'SpotMarketProxy');
    final oracleManagerAbi = ContractAbi.fromJson(oracleManagerAbiJson, 'OracleManager');
    erc20Abi = ContractAbi.fromJson(erc20AbiJson, 'ERC20');

    spotMarketContract = DeployedContract(
      spotMarketAbi,
      EthereumAddress.fromHex(spotMarketProxyAddress),
    );
    oracleManagerContract = DeployedContract(
      oracleManagerAbi,
      EthereumAddress.fromHex(oracleManagerAddress),
    );
  }

  void dispose() {
    _web3Client.dispose();
  }

  /// Get available spot markets from Synthetix v3
  Future<List<Map<String, dynamic>>> getAvailableMarkets() async {
    try {
      // TODO: Call SpotMarketProxy.getMarkets() to get list of available spot markets
      // Returns: List of market configs with IDs, fees, etc.
      return [];
    } catch (e) {
      throw Exception('Failed to fetch available markets: $e');
    }
  }

  /// Get market details from Synthetix v3
  Future<Map<String, dynamic>> getMarketDetails(int marketId) async {
    try {
      // TODO: Call SpotMarketProxy.getMarketSummary(marketId)
      // Returns: price, skew, timestamp, etc.
      return {};
    } catch (e) {
      throw Exception('Failed to fetch market details: $e');
    }
  }

  /// Get current price from OracleManager via Pyth oracle
  Future<double> getCurrentPrice(String nodeId) async {
    try {
      final processFunction = oracleManagerContract.function('process');
      
      // Convert nodeId hex string to BigInt for bytes32
      final nodeIdBigInt = BigInt.parse(nodeId.replaceFirst('0x', ''), radix: 16);
      
      final result = await _web3Client.call(
        contract: oracleManagerContract,
        function: processFunction,
        params: [nodeIdBigInt],
        atBlock: const BlockNum.current(),
      );

      // Result is a tuple with (price, timestamp, ...)
      // Price is returned as int256 with 18 decimals
      final priceRaw = result[0] as BigInt;
      final price = priceRaw.toDouble() / 1e18;
      
      return price;
    } catch (e) {
      throw Exception('Failed to fetch price from oracle: $e');
    }
  }

  /// Estimate gas for a transaction
  Future<Map<String, dynamic>> estimateGas({
    required Transaction transaction,
  }) async {
    try {
      final gasLimit = await _web3Client.estimateGas(
        sender: transaction.from,
        to: transaction.to,
        value: transaction.value,
        data: transaction.data,
      );

      final gasPriceAmount = await _web3Client.getGasPrice();
      final gasPrice = gasPriceAmount.getInWei;
      final totalCostWei = gasLimit * gasPrice;
      final totalCostEth = totalCostWei.toDouble() / 1e18;

      return {
        'gasLimit': gasLimit,
        'gasPrice': gasPrice,
        'totalCostWei': totalCostWei,
        'totalCostEth': totalCostEth.toStringAsFixed(6),
      };
    } catch (e) {
      throw Exception('Failed to estimate gas: $e');
    }
  }

  /// Get quote for buying synths (how much synth you'll receive for USD)
  Future<Map<String, dynamic>> getQuoteBuyExactIn({
    required int marketId,
    required BigInt usdAmount,
  }) async {
    try {
      final quoteBuyFunction = spotMarketContract.function('quoteBuyExactIn');
      
      final result = await _web3Client.call(
        contract: spotMarketContract,
        function: quoteBuyFunction,
        params: [BigInt.from(marketId), usdAmount],
      );

      return {
        'synthAmount': result[0] as BigInt,
        'fees': result[1],
      };
    } catch (e) {
      throw Exception('Failed to get buy quote: $e');
    }
  }

  /// Get quote for selling synths (how much USD you'll receive for synths)
  Future<Map<String, dynamic>> getQuoteSellExactIn({
    required int marketId,
    required BigInt synthAmount,
  }) async {
    try {
      final quoteSellFunction = spotMarketContract.function('quoteSellExactIn');
      
      final result = await _web3Client.call(
        contract: spotMarketContract,
        function: quoteSellFunction,
        params: [BigInt.from(marketId), synthAmount],
      );

      return {
        'usdAmount': result[0] as BigInt,
        'fees': result[1],
      };
    } catch (e) {
      throw Exception('Failed to get sell quote: $e');
    }
  }

  /// Get market skew (difference between long and short positions)
  Future<BigInt> getMarketSkew(int marketId) async {
    try {
      final getSkewFunction = spotMarketContract.function('getMarketSkew');
      
      final result = await _web3Client.call(
        contract: spotMarketContract,
        function: getSkewFunction,
        params: [BigInt.from(marketId)],
      );

      return result[0] as BigInt;
    } catch (e) {
      throw Exception('Failed to fetch market skew: $e');
    }
  }

  /// Execute a buy order on Synthetix v3 spot market
  /// Requires user to have approved collateral token spending
  Future<String> executeBuyOrder({
    required int marketId,
    required BigInt usdAmount,
    required BigInt minSynthAmount,
    required Credentials credentials,
    String? referrer,
  }) async {
    try {
      final buyFunction = spotMarketContract.function('buy');
      
      final referrerAddress = referrer != null
          ? EthereumAddress.fromHex(referrer)
          : EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

      final transaction = Transaction.callContract(
        contract: spotMarketContract,
        function: buyFunction,
        parameters: [
          BigInt.from(marketId),
          usdAmount,
          minSynthAmount,
          referrerAddress,
        ],
      );

      final txHash = await _web3Client.sendTransaction(
        credentials,
        transaction,
        chainId: 84532, // Base Sepolia
      );

      return txHash;
    } catch (e) {
      throw Exception('Failed to execute buy order: $e');
    }
  }

  /// Execute a sell order on Synthetix v3 spot market
  /// Requires user to have approved synth token spending
  Future<String> executeSellOrder({
    required int marketId,
    required BigInt synthAmount,
    required BigInt minUsdAmount,
    required Credentials credentials,
    String? referrer,
  }) async {
    try {
      final sellFunction = spotMarketContract.function('sell');
      
      final referrerAddress = referrer != null
          ? EthereumAddress.fromHex(referrer)
          : EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

      final transaction = Transaction.callContract(
        contract: spotMarketContract,
        function: sellFunction,
        parameters: [
          BigInt.from(marketId),
          synthAmount,
          minUsdAmount,
          referrerAddress,
        ],
      );

      final txHash = await _web3Client.sendTransaction(
        credentials,
        transaction,
        chainId: 84532, // Base Sepolia
      );

      return txHash;
    } catch (e) {
      throw Exception('Failed to execute sell order: $e');
    }
  }

  /// Get user's balance of a specific synth token
  Future<BigInt> getSynthBalance({
    required String synthTokenAddress,
    required String userAddress,
  }) async {
    try {
      final tokenContract = DeployedContract(
        erc20Abi,
        EthereumAddress.fromHex(synthTokenAddress),
      );
      final balanceOfFunction = tokenContract.function('balanceOf');
      
      final result = await _web3Client.call(
        contract: tokenContract,
        function: balanceOfFunction,
        params: [EthereumAddress.fromHex(userAddress)],
      );

      return result[0] as BigInt;
    } catch (e) {
      throw Exception('Failed to fetch synth balance: $e');
    }
  }

  /// Get user's balance of collateral token
  Future<BigInt> getCollateralBalance({
    required String collateralTokenAddress,
    required String userAddress,
  }) async {
    try {
      final tokenContract = DeployedContract(
        erc20Abi,
        EthereumAddress.fromHex(collateralTokenAddress),
      );
      final balanceOfFunction = tokenContract.function('balanceOf');
      
      final result = await _web3Client.call(
        contract: tokenContract,
        function: balanceOfFunction,
        params: [EthereumAddress.fromHex(userAddress)],
      );

      return result[0] as BigInt;
    } catch (e) {
      throw Exception('Failed to fetch collateral balance: $e');
    }
  }

  /// Approve spending of token for SpotMarketProxy
  Future<String> approveTokenSpending({
    required String tokenAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    try {
      final tokenContract = DeployedContract(
        erc20Abi,
        EthereumAddress.fromHex(tokenAddress),
      );
      final approveFunction = tokenContract.function('approve');
      
      final transaction = Transaction.callContract(
        contract: tokenContract,
        function: approveFunction,
        parameters: [
          EthereumAddress.fromHex(spotMarketProxyAddress),
          amount,
        ],
      );

      final txHash = await _web3Client.sendTransaction(
        credentials,
        transaction,
        chainId: 84532, // Base Sepolia
      );

      return txHash;
    } catch (e) {
      throw Exception('Failed to approve token spending: $e');
    }
  }

  /// Check allowance for SpotMarketProxy
  Future<BigInt> getAllowance({
    required String tokenAddress,
    required String userAddress,
  }) async {
    try {
      final tokenContract = DeployedContract(
        erc20Abi,
        EthereumAddress.fromHex(tokenAddress),
      );
      final allowanceFunction = tokenContract.function('allowance');
      
      final result = await _web3Client.call(
        contract: tokenContract,
        function: allowanceFunction,
        params: [
          EthereumAddress.fromHex(userAddress),
          EthereumAddress.fromHex(spotMarketProxyAddress),
        ],
      );

      return result[0] as BigInt;
    } catch (e) {
      throw Exception('Failed to fetch allowance: $e');
    }
  }

  /// Get transaction receipt and status
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    try {
      return await _web3Client.getTransactionReceipt(txHash);
    } catch (e) {
      throw Exception('Failed to get transaction receipt: $e');
    }
  }

  /// Listen to market updates
  /// Subscribe to relevant events from SpotMarketProxy
  Stream<Map<String, dynamic>> watchMarketUpdates(int marketId) async* {
    try {
      // Listen for OrderSettled events
      final orderSettledEvent = spotMarketContract.event('OrderSettled');

      // Filter for specific market
      final filterOptions = FilterOptions.events(
        contract: spotMarketContract,
        event: orderSettledEvent,
      );

      // Create stream of events
      final eventStream = _web3Client.events(filterOptions);

      await for (final event in eventStream) {
        final decoded = orderSettledEvent.decodeResults(
          event.topics ?? [],
          event.data ?? '',
        );

        yield {
          'event': 'OrderSettled',
          'marketId': decoded[0],
          'trader': decoded[1],
          'amount': decoded[2],
          'price': decoded[3],
          'timestamp': DateTime.now(),
        };
      }
    } catch (e) {
      throw Exception('Failed to watch market updates: $e');
    }
  }

  /// Start listening to all market events for real-time updates
  Stream<Map<String, dynamic>> watchAllMarketEvents() async* {
    try {
      final orderSettledEvent = spotMarketContract.event('OrderSettled');
      
      final filterOptions = FilterOptions.events(
        contract: spotMarketContract,
        event: orderSettledEvent,
      );

      final eventStream = _web3Client.events(filterOptions);

      await for (final event in eventStream) {
        try {
          final decoded = orderSettledEvent.decodeResults(
            event.topics ?? [],
            event.data ?? '',
          );

          yield {
            'event': 'OrderSettled',
            'marketId': decoded[0],
            'transactionHash': event.transactionHash,
            'timestamp': DateTime.now(),
          };
        } catch (decodeError) {
          // Skip events that can't be decoded
          continue;
        }
      }
    } catch (e) {
      throw Exception('Failed to watch events: $e');
    }
  }

  /// Get aggregated market data
  Future<Map<String, dynamic>> getAggregatedMarketData() async {
    try {
      // TODO: Fetch market summaries, volumes, etc.
      // Can aggregate data from multiple markets
      return {};
    } catch (e) {
      throw Exception('Failed to fetch aggregated market data: $e');
    }
  }
}

/// Model for Synthetix v3 market data
class SynthetixMarket {
  final int marketId;
  final String symbol;
  final String synthTokenAddress;
  final String collateralTokenAddress;
  final int decimals;
  final double currentPrice;
  final BigInt totalVolume;
  final double skew;
  final DateTime lastUpdated;

  SynthetixMarket({
    required this.marketId,
    required this.symbol,
    required this.synthTokenAddress,
    required this.collateralTokenAddress,
    required this.decimals,
    required this.currentPrice,
    required this.totalVolume,
    required this.skew,
    required this.lastUpdated,
  });
}

/// Model for user's spot market position
class SpotMarketPosition {
  final String marketId;
  final String symbol;
  final BigInt quantity;
  final double averageEntryPrice;
  final BigInt collateralLocked;
  final DateTime openedAt;
  final String status; // 'open', 'closed', 'liquidated'

  SpotMarketPosition({
    required this.marketId,
    required this.symbol,
    required this.quantity,
    required this.averageEntryPrice,
    required this.collateralLocked,
    required this.openedAt,
    required this.status,
  });
}
