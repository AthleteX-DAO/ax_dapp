import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:http/http.dart' as http;
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
      print('SynthetixCoreService.getUserAccounts: user=$userAddress');

      final tokenAddressResult = await _client.call(
        contract: _coreProxy,
        function: _coreProxy.function('getAccountTokenAddress'),
        params: [],
      );

      final accountTokenAddress = tokenAddressResult[0] as EthereumAddress;
      print(
        'SynthetixCoreService.getUserAccounts: accountToken=$accountTokenAddress',
      );

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
      print('SynthetixCoreService.getUserAccounts: balance=$balance');

      final accounts = <BigInt>[];
      for (var i = BigInt.zero; i < balance; i += BigInt.one) {
        final tokenResult = await _client.call(
          contract: accountToken,
          function: accountToken.function('tokenOfOwnerByIndex'),
          params: [owner, i],
        );
        final tokenId = tokenResult[0] as BigInt;
        print('SynthetixCoreService.getUserAccounts: tokenId=$tokenId');
        accounts.add(tokenId);
      }

      print('SynthetixCoreService.getUserAccounts: count=${accounts.length}');
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
    print(
      'SynthetixCoreService.createAccount: sending tx chainId=${SynthetixConfig.chainId}',
    );
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('createAccount'),
      parameters: [],
    );

    final txHash = await _sendWithGasBuffer(transaction, credentials);
    print('SynthetixCoreService.createAccount: txHash=$txHash');
    return txHash;
  }

  /// Deposit collateral (requires transaction + prior approval)
  Future<String> depositCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
    final transaction = Transaction.callContract(
      contract: _coreProxy,
      function: _coreProxy.function('deposit'),
      parameters: [
        BigInt.from(accountId),
        EthereumAddress.fromHex(collateralAddress),
        amount,
      ],
    );

    return _sendWithGasBuffer(transaction, credentials);
  }

  /// Withdraw collateral from account
  Future<String> withdrawCollateral({
    required int accountId,
    required String collateralAddress,
    required BigInt amount,
    required Credentials credentials,
  }) async {
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
  Future<String> _sendWithGasBuffer(
    Transaction transaction,
    Credentials credentials,
  ) async {
    final estimatedGas = await _client.estimateGas(
      sender: EthereumAddress.fromHex(
        await credentials.extractAddress().then((a) => a.hex),
      ),
      to: transaction.to,
      data: transaction.data,
    );
    // Apply 1.3× buffer (round up to nearest integer)
    final bufferedGas = (estimatedGas * BigInt.from(13)) ~/ BigInt.from(10);
    final txWithGas = transaction.copyWith(maxGas: bufferedGas.toInt());
    return _client.sendTransaction(
      credentials,
      txWithGas,
      chainId: SynthetixConfig.chainId,
    );
  }

  void dispose() {
    _client.dispose();
  }
}
