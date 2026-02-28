import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/json_rpc.dart' show RPCError;
import 'package:web3dart/web3dart.dart';

/// Service for interacting with Synthetix V3 Core system
class SynthetixCoreService {

  SynthetixCoreService() {
    _client = Web3Client(SynthetixConfig.rpcUrl, http.Client());
    _initContracts();
  }
  late Web3Client _client;
  late DeployedContract _coreProxy;
  late DeployedContract _usdProxy;

  Web3Client get client => _client;

  void _initContracts() {
    // Core Proxy ABI
    final coreAbi = ContractAbi.fromJson('''
    [
      {
        "inputs": [],
        "name": "createAccount",
        "outputs": [{"internalType": "uint128", "name": "accountId", "type": "uint128"}],
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
        "inputs": [],
        "name": "getAccountTokenAddress",
        "outputs": [{"internalType": "address", "name": "", "type": "address"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "tokenAmount", "type": "uint256"}
        ],
        "name": "deposit",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "tokenAmount", "type": "uint256"}
        ],
        "name": "withdraw",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "amount", "type": "uint256"},
          {"internalType": "uint256", "name": "leverage", "type": "uint256"}
        ],
        "name": "delegateCollateral",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "amount", "type": "uint256"}
        ],
        "name": "undelegateCollateral",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "amount", "type": "uint256"}
        ],
        "name": "mintUsd",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"},
          {"internalType": "uint256", "name": "amount", "type": "uint256"}
        ],
        "name": "burnUsd",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"}
        ],
        "name": "getAccountCollateral",
        "outputs": [
          {"internalType": "uint256", "name": "totalDeposited", "type": "uint256"},
          {"internalType": "uint256", "name": "totalAssigned", "type": "uint256"},
          {"internalType": "uint256", "name": "totalLocked", "type": "uint256"}
        ],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"}
        ],
        "name": "getAccountAvailableCollateral",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"}
        ],
        "name": "getPositionDebt",
        "outputs": [{"internalType": "int256", "name": "", "type": "int256"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [
          {"internalType": "uint128", "name": "accountId", "type": "uint128"},
          {"internalType": "uint128", "name": "poolId", "type": "uint128"},
          {"internalType": "address", "name": "collateralType", "type": "address"}
        ],
        "name": "getPositionCollateralRatio",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''', 'CoreProxy',);

    final usdAbi = ContractAbi.fromJson('''
    [
      {
        "inputs": [{"internalType": "address", "name": "account", "type": "address"}],
        "name": "balanceOf",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "totalSupply",
        "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
        "stateMutability": "view",
        "type": "function"
      }
    ]
    ''', 'USDProxy',);

    _coreProxy = DeployedContract(
      coreAbi,
      EthereumAddress.fromHex(SynthetixConfig.coreProxy),
    );

    _usdProxy = DeployedContract(
      usdAbi,
      EthereumAddress.fromHex(SynthetixConfig.usdProxy),
    );
  }

  /// Get user's account IDs
  Future<List<BigInt>> getUserAccounts(String userAddress) async {
    try {
      final tokenAddressResult = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getAccountTokenAddress'),
        params: [],
      );

      final accountTokenAddress = tokenAddressResult[0] as EthereumAddress;

      final accountTokenAbi = ContractAbi.fromJson('''
      [
        {
          "inputs": [{"internalType": "address", "name": "owner", "type": "address"}],
          "name": "balanceOf",
          "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {"internalType": "address", "name": "owner", "type": "address"},
            {"internalType": "uint256", "name": "index", "type": "uint256"}
          ],
          "name": "tokenOfOwnerByIndex",
          "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}],
          "stateMutability": "view",
          "type": "function"
        }
      ]
      ''', 'AccountToken',);

      final accountToken = DeployedContract(
        accountTokenAbi,
        accountTokenAddress,
      );

      final owner = EthereumAddress.fromHex(userAddress);
      final balanceResult = await _client.call(
        contract: accountToken,
        function: accountToken.function('balanceOf'),
        params: [owner],
      );

      final balance = balanceResult[0] as BigInt;

      // Fire all tokenOfOwnerByIndex calls concurrently — one RPC round-trip
      // per token instead of N sequential awaits.
      final indices = List.generate(balance.toInt(), BigInt.from);
      final tokenResults = await Future.wait(
        indices.map(
          (i) => _client.call(
            contract: accountToken,
            function: accountToken.function('tokenOfOwnerByIndex'),
            params: [owner, i],
          ),
        ),
      );

      final accounts = tokenResults.map((r) => r[0] as BigInt).toList();
      return accounts;
    } catch (e) {
      print('Error getting user accounts: $e');
      return [];
    }
  }

  /// Get USD balance for an address
  Future<BigInt> getUSDBalance(String address) async {
    try {
      final result = await _client.call(
        contract: _usdProxy,
        function: _usdProxy.function('balanceOf'),
        params: [EthereumAddress.fromHex(address)],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting USD balance: $e');
      return BigInt.zero;
    }
  }

  /// Get total USD supply
  Future<BigInt> getTotalUSDSupply() async {
    try {
      final result = await _client.call(
        contract: _usdProxy,
        function: _usdProxy.function('totalSupply'),
        params: [],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting total supply: $e');
      return BigInt.zero;
    }
  }

  /// Get collateral info for an account
  Future<Map<String, BigInt>> getAccountCollateral(
    int accountId,
    String collateralAddress,
  ) async {
    try {
      final result = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getAccountCollateral'),
        params: [
          BigInt.from(accountId),
          EthereumAddress.fromHex(collateralAddress),
        ],
      );
      return {
        'totalDeposited': result[0] as BigInt,
        'totalAssigned': result[1] as BigInt,
        'totalLocked': result[2] as BigInt,
      };
    } catch (e) {
      print('Error getting account collateral: $e');
      return {
        'totalDeposited': BigInt.zero,
        'totalAssigned': BigInt.zero,
        'totalLocked': BigInt.zero,
      };
    }
  }

  /// Create a new account (requires transaction)
  /// Returns the transaction hash. The account ID is auto-generated by Synthetix.
  Future<String> createAccount(
    Credentials credentials,
  ) async {
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('createAccount'),
      parameters: [],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Deposit collateral (requires transaction + prior approval)
  Future<String> depositCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    debugPrint('>>> depositCollateral called: accountId=$accountId, collateral=$collateralAddress, amount=$amount');
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Deposit amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('deposit'),
      parameters: [
        BigInt.from(accountId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );
    debugPrint('>>> depositCollateral transaction prepared, calling _sendWithGasBuffer...');

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Withdraw collateral from account
  Future<String> withdrawCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Withdraw amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('withdraw'),
      parameters: [
        BigInt.from(accountId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Delegate collateral to a liquidity pool
  /// This commits your collateral to back a pool and earn yield
  Future<String> delegateCollateral({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
    BigInt? leverage, // 1e18 = 1x leverage
  }) async {
    debugPrint('>>> delegateCollateral called:');
    debugPrint('>>>   accountId: $accountId (${BigInt.from(accountId).toRadixString(16)})');
    debugPrint('>>>   poolId: $poolId (${BigInt.from(poolId).toRadixString(16)})');
    debugPrint('>>>   collateralAddress: $collateralAddress');
    debugPrint('>>>   amount: $amount');
    debugPrint('>>>   leverage: ${leverage ?? BigInt.from(1000000000000000000)}');
    
    if (accountId <= 0) {
      throw ArgumentError.value(accountId, 'accountId', 'Account ID must be > 0');
    }
    if (poolId <= 0) {
      throw ArgumentError.value(poolId, 'poolId', 'Pool ID must be > 0');
    }
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Delegate amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('delegateCollateral'),
      parameters: [
        BigInt.from(accountId),
        BigInt.from(poolId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
        leverage ?? BigInt.from(1000000000000000000), // 1e18 = 1x default
      ],
    );
    debugPrint('>>> delegateCollateral transaction prepared, calling _sendWithGasBuffer...');

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Undelegate collateral from a liquidity pool
  Future<String> undelegateCollateral({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    if (accountId <= 0) {
      throw ArgumentError.value(accountId, 'accountId', 'Account ID must be > 0');
    }
    if (poolId <= 0) {
      throw ArgumentError.value(poolId, 'poolId', 'Pool ID must be > 0');
    }
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Undelegate amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('undelegateCollateral'),
      parameters: [
        BigInt.from(accountId),
        BigInt.from(poolId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Mint/borrow sUSD against delegated collateral
  Future<String> mintUsd({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Mint amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('mintUsd'),
      parameters: [
        BigInt.from(accountId),
        BigInt.from(poolId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Burn/repay sUSD debt
  Future<String> burnUsd({
    required int accountId,
    required int poolId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    if (amount <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Burn amount must be > 0');
    }
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('burnUsd'),
      parameters: [
        BigInt.from(accountId),
        BigInt.from(poolId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Get available (unassigned) collateral that can be withdrawn
  Future<BigInt> getAccountAvailableCollateral(
    int accountId,
    String collateralAddress,
  ) async {
    try {
      final result = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getAccountAvailableCollateral'),
        params: [
          BigInt.from(accountId),
          EthereumAddress.fromHex(collateralAddress),
        ],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting available collateral: $e');
      return BigInt.zero;
    }
  }

  /// Get debt position for account in a pool
  Future<BigInt> getPositionDebt(
    int accountId,
    int poolId,
    String collateralAddress,
  ) async {
    try {
      final result = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getPositionDebt'),
        params: [
          BigInt.from(accountId),
          BigInt.from(poolId),
          EthereumAddress.fromHex(collateralAddress),
        ],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting position debt: $e');
      return BigInt.zero;
    }
  }

  /// Get collateralization ratio (c-ratio) for a position
  /// Returns ratio in 18 decimals (e.g., 400e18 = 400%)
  Future<BigInt> getPositionCollateralRatio(
    int accountId,
    int poolId,
    String collateralAddress,
  ) async {
    try {
      final result = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getPositionCollateralRatio'),
        params: [
          BigInt.from(accountId),
          BigInt.from(poolId),
          EthereumAddress.fromHex(collateralAddress),
        ],
      );
      return result[0] as BigInt;
    } catch (e) {
      print('Error getting c-ratio: $e');
      return BigInt.zero;
    }
  }

  /// Sends [transaction] with a 1.3× gas buffer applied to the web3dart
  /// estimate, guarding against OOG failures on first-time storage writes
  /// (common on Polygon mainnet).
  ///
  /// Throws a descriptive [Exception] on RPC errors, estimation failures, or
  /// an empty transaction hash so callers always receive a meaningful error.
  Future<String> _sendWithGasBuffer(
    Transaction transaction,
    Credentials credentials,
  ) async {
    debugPrint('>>> _sendWithGasBuffer called');
    debugPrint('>>> transaction.to: ${transaction.to}');
    debugPrint('>>> transaction.data: ${transaction.data}');
    try {
      final senderAddress = await credentials.extractAddress();
      debugPrint('>>> sender: ${senderAddress.hex}');
      
      final estimatedGas = await _client.estimateGas(
        sender: EthereumAddress.fromHex(senderAddress.hex),
        to: transaction.to,
        data: transaction.data,
      );
      debugPrint('>>> estimatedGas: $estimatedGas');
      // Apply 1.3× buffer (round up to nearest integer)
      final bufferedGas = (estimatedGas * BigInt.from(13)) ~/ BigInt.from(10);
      debugPrint('>>> bufferedGas: $bufferedGas');
      final txWithGas = transaction.copyWith(maxGas: bufferedGas.toInt());
      debugPrint('>>> Sending transaction to chainId: ${SynthetixConfig.chainId}');
      final txHash = await _client.sendTransaction(
        credentials,
        txWithGas,
        chainId: SynthetixConfig.chainId,
      );
      debugPrint('>>> txHash returned: $txHash');
      if (txHash.isEmpty) {
        throw Exception('Transaction returned an empty hash — possible RPC issue');
      }
      return txHash;
    } on RPCError catch (e) {
      debugPrint('>>> RPCError: ${e.message}');
      debugPrint('>>> RPCError code: ${e.errorCode}');
      throw Exception('Contract reverted: ${e.message}');
    } catch (e, stack) {
      debugPrint('>>> Exception in _sendWithGasBuffer: $e');
      debugPrint('>>> Stack: $stack');
      rethrow;
    }
  }

  /// Poll until a transaction is mined and confirmed.
  /// Throws on timeout (60 s) or on-chain revert.
  Future<void> waitForReceipt(String txHash) async {
    const maxAttempts = 30;
    const delay = Duration(seconds: 2);
    for (var i = 0; i < maxAttempts; i++) {
      final receipt = await _client.getTransactionReceipt(txHash);
      if (receipt != null) {
        if (receipt.status == false) {
          throw Exception('Transaction reverted on-chain');
        }
        return;
      }
      await Future<void>.delayed(delay);
    }
    throw Exception('Transaction confirmation timeout after 60 s');
  }

  void dispose() {
    _client.dispose();
  }
}
