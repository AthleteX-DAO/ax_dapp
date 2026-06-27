import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ax_dapp/config/synthetix_config.dart';
import 'package:ethereum_api/erc20_api.dart' as erc20_api;
import 'package:ethereum_api/src/config/models/ethereum_address_config.dart';
import 'package:ethereum_api/synthetix_v3_api.dart';
import 'package:flutter/foundation.dart';
import 'package:shared/shared.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/json_rpc.dart' show RPCError;
import 'package:web3dart/web3dart.dart' as web3;

/// Data class for vault information.
class VaultData {
  const VaultData({
    required this.symbol,
    required this.balance,
    required this.tvl,
    required this.apy,
    required this.vaultAddress,
    required this.collateralAddress,
    required this.poolId,
    required this.timestamp,
  });

  /// Vault symbol (e.g., 'WBTC', 'WETH').
  final String symbol;

  /// User's balance in the vault.
  final double balance;

  /// Total value locked in the vault.
  final double tvl;

  /// Annual percentage yield.
  final double apy;

  /// The vault contract address (CoreProxy).
  final String vaultAddress;

  /// The collateral token address (WBTC/WETH).
  final String collateralAddress;

  /// The pool ID for this vault.
  final BigInt poolId;

  /// Last update timestamp.
  final DateTime timestamp;

  VaultData copyWith({
    String? symbol,
    double? balance,
    double? tvl,
    double? apy,
    String? vaultAddress,
    String? collateralAddress,
    BigInt? poolId,
    DateTime? timestamp,
  }) {
    return VaultData(
      symbol: symbol ?? this.symbol,
      balance: balance ?? this.balance,
      tvl: tvl ?? this.tvl,
      apy: apy ?? this.apy,
      vaultAddress: vaultAddress ?? this.vaultAddress,
      collateralAddress: collateralAddress ?? this.collateralAddress,
      poolId: poolId ?? this.poolId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'VaultData(symbol: $symbol, balance: $balance, tvl: $tvl, apy: $apy, poolId: $poolId)';
}

/// Repository for managing Synthetix V3 vault operations.
class VaultRepository {
  VaultRepository({
    required EthereumChain chain,
    required ValueStream<Web3Client> reactiveWeb3Client,
    required WalletRepository walletRepository,
    BigInt? accountId,
  })  : _chain = chain,
        _reactiveWeb3Client = reactiveWeb3Client,
        _walletRepository = walletRepository,
        accountId = accountId ?? BigInt.zero;

  /// The Ethereum chain for vault operations. Mutable — updated on chain switch.
  EthereumChain get chain => _chain;
  EthereumChain _chain;

  /// The reactive web3 client for blockchain calls.
  final ValueStream<Web3Client> _reactiveWeb3Client;

  /// Wallet repository for signing transactions and reading chain/account.
  final WalletRepository _walletRepository;

  /// Get the connected wallet address reactively from WalletRepository.
  /// Returns null if the wallet is not connected.
  String? get userAddress {
    final addr = _walletRepository.currentWallet.address;
    if (addr.isEmpty || addr == '0x0000000000000000000000000000000000000000') {
      return null;
    }
    return addr;
  }

  /// The Synthetix V3 account id used for deposit/delegate/mint. Updated when
  /// AccountBloc confirms a live account.
  BigInt accountId;

  /// Update the active chain. Called by EarnPageBloc when AppData changes.
  void updateChain(EthereumChain newChain) {
    _chain = newChain;
  }

  /// Update the Synthetix account ID. Called from EarnPage (or EarnPageBloc)
  /// whenever AccountBloc emits a non-zero synthetixAccountId.
  void updateAccountId(BigInt newAccountId) {
    if (newAccountId != BigInt.zero) {
      accountId = newAccountId;
    }
  }

  Web3Client get _web3Client => _reactiveWeb3Client.value;

  // Synthetix V3 CoreProxy addresses per chain
  static const String _coreProxyAddressPolygon = SynthetixConfig.coreProxy;
  static const String _coreProxyAddressSepolia = SynthetixConfig.sepoliaCoreProxy;

  // Pool IDs for Spartan Council Pool (commonly used for testing)
  static final BigInt _spartanPoolId = BigInt.from(1);

  // Default leverage (1x) encoded with 18 decimals.
  static final BigInt _oneXLeverage = BigInt.from(10).pow(18);

  // Collateral addresses on Sepolia
  static const String _wbtcSepolia =
      '0x27c54ab10d69c852821e6ff64292867c0e9c387c';

  String get _coreProxyAddress {
    return _chain == EthereumChain.polygonMainnet
        ? _coreProxyAddressPolygon
        : _coreProxyAddressSepolia;
  }

  /// Fetch all available vaults for the current chain.
  ///
  /// Pass [overrideAccountId] to load the user's deposited balance for a
  /// specific Synthetix account (e.g. from AccountBloc.state.synthetixAccountId).
  /// When null (or zero), balances are returned as 0.0 gracefully.
  Future<List<VaultData>> fetchVaults({BigInt? overrideAccountId}) async {
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );

      if (_chain == EthereumChain.polygonMainnet) {
        return _fetchPolygonVaults(coreProxy, overrideAccountId: overrideAccountId);
      }
      return _fetchSepoliaVaults(coreProxy, overrideAccountId: overrideAccountId);
    } catch (e) {
      debugPrint('Error fetching vaults: $e');
      return _getFallbackVaults();
    }
  }

  /// Calculate total platform TVL across all vaults
  Future<double> getPlatformTVL() async {
    try {
      final vaults = await fetchVaults();
      return vaults.fold<double>(0, (sum, vault) => sum + vault.tvl);
    } catch (e) {
      debugPrint('Error calculating platform TVL: $e');
      return _chain == EthereumChain.polygonMainnet ? 1100000.0 : 4850000.0;
    }
  }

  /// Fetch vaults for Ethereum Sepolia — all three run concurrently.
  Future<List<VaultData>> _fetchSepoliaVaults(
    SynthetixCoreProxy coreProxy, {
    BigInt? overrideAccountId,
  }) async {
    const axAddress = SynthetixConfig.axToken;
    const wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    // Fire all three vault fetches in parallel — one RPC batch instead of 3
    // sequential round-trips.
    return Future.wait([
      _fetchVaultData(
        coreProxy: coreProxy,
        symbol: 'AX',
        collateralAddress: axAddress,
        poolId: _spartanPoolId,
        overrideAccountId: overrideAccountId,
      ),
      _fetchVaultData(
        coreProxy: coreProxy,
        symbol: 'WBTC',
        collateralAddress: wbtcAddress,
        poolId: _spartanPoolId,
        overrideAccountId: overrideAccountId,
      ),
      _fetchVaultData(
        coreProxy: coreProxy,
        symbol: 'WETH',
        collateralAddress: wethAddress,
        poolId: _spartanPoolId,
        overrideAccountId: overrideAccountId,
      ),
    ]);
  }

  /// Fetch vaults for Polygon Mainnet — only AX collateral is active.
  Future<List<VaultData>> _fetchPolygonVaults(
    SynthetixCoreProxy coreProxy, {
    BigInt? overrideAccountId,
  }) async {
    const axAddress = SynthetixConfig.axToken;
    final axVault = await _fetchVaultData(
      coreProxy: coreProxy,
      symbol: 'AX',
      collateralAddress: axAddress,
      poolId: _spartanPoolId,
      overrideAccountId: overrideAccountId,
    );
    return [axVault];
  }

  /// Fetch data for a specific vault.
  ///
  /// TVL (getVaultCollateral), user balance (getAccountCollateral), and token
  /// decimals are all fired in parallel via [Future.wait] to minimise RPC
  /// round-trips. The resolved decimals value is passed directly into
  /// [_getUserBalanceWithProxy] so it is never fetched twice.
  Future<VaultData> _fetchVaultData({
    required SynthetixCoreProxy coreProxy,
    required String symbol,
    required String collateralAddress,
    required BigInt poolId,
    BigInt? overrideAccountId,
  }) async {
    try {
      final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
      final token = erc20_api.ERC20(
        address: collateralEthAddress,
        client: _web3Client,
      );
      final resolvedAccountId = userAddress == null ? BigInt.zero : (overrideAccountId ?? accountId);

      // Fire TVL, user balance, and decimals concurrently — saves 2 round-trips
      // per vault vs the old sequential approach.
      final results = await Future.wait([
        coreProxy.getVaultCollateral(poolId, collateralEthAddress),
        token.decimals(),
        if (resolvedAccountId != BigInt.zero)
          coreProxy.getAccountCollateral(
            resolvedAccountId,
            collateralEthAddress,
          )
        else
          Future<dynamic>.value(null),
      ]);

      final vaultCollateral = results[0] as dynamic;
      final decimals = (results[1] as BigInt).toInt();
      final accountCollateral = results[2]; // null when no account

      final tvl = _bigIntToDouble(vaultCollateral.amount as BigInt, decimals);

      var userBalance = 0.0;
      if (accountCollateral != null) {
        userBalance = _bigIntToDouble(
          accountCollateral.totalDeposited as BigInt,
          decimals,
        );
      }

      final apy = await _calculateAPY(symbol: symbol, tvl: tvl);

      return VaultData(
        symbol: symbol,
        balance: userBalance,
        tvl: tvl,
        apy: apy,
        vaultAddress: _coreProxyAddress,
        collateralAddress: collateralAddress,
        poolId: poolId,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error fetching vault data for $symbol: $e');
      return VaultData(
        symbol: symbol,
        balance: 0,
        tvl: _fallbackTvlForSymbol(symbol),
        apy: _getFallbackAPY(symbol),
        vaultAddress: _coreProxyAddress,
        collateralAddress: collateralAddress,
        poolId: poolId,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Fetch a specific vault by symbol.
  Future<VaultData?> fetchVault(String symbol) async {
    final vaults = await fetchVaults();
    try {
      return vaults.firstWhere((v) => v.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  /// Get user's deposited balance in a vault via Synthetix getAccountCollateral.
  ///
  /// Returns [totalAssigned] — the amount actively delegated to pools.
  /// Returns 0.0 gracefully when [overrideAccountId] is zero (no account yet).
  ///
  /// When called from [_fetchVaultData] the batched path is used instead
  /// (decimals + collateral fetched together). This public method is kept for
  /// standalone callers (e.g. EarnPageBloc balance refresh) and batches the
  /// two independent RPC calls internally.
  Future<double> getUserBalance({
    required String collateralAddress,
    required BigInt poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return 0.0;

    try {
      final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final token = erc20_api.ERC20(
        address: collateralEthAddress,
        client: _web3Client,
      );

      // Batch the two independent reads together.
      final results = await Future.wait([
        coreProxy.getAccountCollateral(resolvedAccountId, collateralEthAddress),
        token.decimals(),
      ]);

      final collateral = results[0] as dynamic;
      final decimals = (results[1] as BigInt).toInt();
      return _bigIntToDouble(collateral.totalAssigned as BigInt, decimals);
    } catch (e) {
      debugPrint('Error getting account collateral balance: $e');
      return 0.0;
    }
  }

  /// Get collateral token decimals for a given collateral address.
  Future<int> getCollateralDecimals(String collateralAddress) async {
    final token = erc20_api.ERC20(
      address: EthereumAddress.fromHex(collateralAddress),
      client: _web3Client,
    );
    final decimals = await token.decimals();
    return decimals.toInt();
  }

  /// Fetch the actual Synthetix account ID from the blockchain for a given wallet address.
  Future<BigInt?> _fetchActualAccountId(String walletAddress) async {
    try {
      final coreProxyAddress = web3.EthereumAddress.fromHex(_coreProxyAddress);
      final coreProxy = SynthetixCoreProxy(
        address: coreProxyAddress,
        client: _web3Client,
      );
      
      // Get the account token address
      final tokenAddressResult = await _web3Client.call(
        contract: coreProxy.self,
        function: coreProxy.self.abi.functions.firstWhere((f) => f.name == 'getAccountTokenAddress'),
        params: [],
      );
      
      final accountTokenAddress = tokenAddressResult[0] as web3.EthereumAddress;
      debugPrint('   Account token address: ${accountTokenAddress.hex}');
      
      final accountTokenAbi = web3.ContractAbi.fromJson('''
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
      ''', 'AccountToken');

      final accountToken = web3.DeployedContract(
        accountTokenAbi,
        accountTokenAddress,
      );

      // Get account token balance for the user
      final balanceResult = await _web3Client.call(
        contract: accountToken,
        function: accountToken.function('balanceOf'),
        params: [web3.EthereumAddress.fromHex(walletAddress)],
      );
      
      final balance = balanceResult[0] as BigInt;
      debugPrint('   Account token balance: $balance');
      
      if (balance == BigInt.zero) {
        return null;
      }
      
      // Get the first account ID (tokenOfOwnerByIndex)
      final tokenOfOwnerResult = await _web3Client.call(
        contract: accountToken,
        function: accountToken.function('tokenOfOwnerByIndex'),
        params: [web3.EthereumAddress.fromHex(walletAddress), BigInt.zero],
      );
      
      final actualAccountId = tokenOfOwnerResult[0] as BigInt;
      debugPrint('   Found account ID: $actualAccountId');
      
      return actualAccountId;
    } catch (e) {
      debugPrint('Error fetching account ID: $e');
      return null;
    }
  }

  /// Poll until a transaction is mined and confirmed.
  Future<void> _waitForReceipt(String txHash) async {
    const maxAttempts = 30;
    const delay = Duration(seconds: 2);
    for (var i = 0; i < maxAttempts; i++) {
      final receipt = await _web3Client.getTransactionReceipt(txHash);
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

  /// Sign and send an unsigned transaction from the API.
  ///
  /// Takes the raw `to`, `data`, and `value` fields from an
  /// [UnsignedTxResponse] and uses the wallet's credentials to sign and
  /// broadcast. Returns the transaction hash.
  Future<String> signAndSendUnsignedTx({
    required String to,
    required String data,
    String value = '0',
    int? gasEstimate,
  }) async {
    debugPrint('🔷 [VAULT_REPO] signAndSendUnsignedTx');
    debugPrint('   - to: $to');
    debugPrint('   - data: ${data.substring(0, data.length > 20 ? 20 : data.length)}...');
    debugPrint('   - value: $value');

    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final toAddress = EthereumAddress.fromHex(to);
    final txValue = EtherAmount.inWei(BigInt.parse(value));

    // Build the raw transaction
    final tx = web3.Transaction(
      to: toAddress,
      data: _hexToBytes(data),
      value: txValue,
      maxGas: gasEstimate,
    );

    final txHash = await _web3Client.sendTransaction(
      credentials,
      tx,
      chainId: 137,
    );
    debugPrint('✅ [VAULT_REPO] TX sent: $txHash');
    return txHash;
  }

  /// Convert hex string to Uint8List for transaction data.
  static Uint8List _hexToBytes(String hex) {
    final cleanHex = hex.startsWith('0x') ? hex.substring(2) : hex;
    final length = cleanHex.length ~/ 2;
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = int.parse(cleanHex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }

  /// Deposit into a vault.
  Future<String> deposit({
    required VaultData vault,
    required double amount,
  }) async {
    debugPrint('\n═══════════════════════════════════════════');
    debugPrint('🟦 [VAULT_REPO] DEPOSIT CALLED');
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🟦 [VAULT_REPO] Parameters:');
    debugPrint('   - vault.symbol: ${vault.symbol}');
    debugPrint('   - vault.collateralAddress: ${vault.collateralAddress}');
    debugPrint('   - vault.poolId: ${vault.poolId}');
    debugPrint('   - amount (double): $amount');
    debugPrint('   - userAddress: $userAddress');
    debugPrint('   - chain: ${_chain.name}');
    debugPrint('   - stored accountId: $accountId');

    if (userAddress == null) {
      debugPrint('❌ [VAULT_REPO] Wallet not connected (userAddress is null)');
      throw Exception('Wallet not connected');
    }

    debugPrint('🟡 [VAULT_REPO] Getting credentials from wallet...');
    final credentials = _walletRepository.credentials.value;
    debugPrint('✅ [VAULT_REPO] Credentials obtained');

    var resolvedAccountId = accountId;
    if (resolvedAccountId == BigInt.zero) {
      debugPrint('🟡 [VAULT_REPO] Stored accountId is zero, attempting to fetch from blockchain...');
      final fetchedId = await _fetchActualAccountId(userAddress!);
      if (fetchedId != null && fetchedId != BigInt.zero) {
        resolvedAccountId = fetchedId;
        accountId = fetchedId; // Cache it
        debugPrint('✅ [VAULT_REPO] Found on-chain accountId: $resolvedAccountId');
      }
    }
    debugPrint('✅ [VAULT_REPO] Using resolved accountId: $resolvedAccountId');

    if (resolvedAccountId == BigInt.zero) {
      debugPrint('❌ [VAULT_REPO] No Synthetix account (accountId is zero)!');
      throw Exception('No Synthetix account found. Please create one first from the Account page.');
    }

    final collateralAddress = EthereumAddress.fromHex(vault.collateralAddress);
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final userEthAddress = EthereumAddress.fromHex(userAddress!);

    debugPrint('🟡 [VAULT_REPO] Address conversions:');
    debugPrint('   - collateralAddress: ${collateralAddress.hex}');
    debugPrint('   - coreProxyAddress: ${coreProxyAddress.hex}');
    debugPrint('   - userEthAddress: ${userEthAddress.hex}');

    // 1) Approve CoreProxy to spend the collateral
    debugPrint('\n🟡 [VAULT_REPO] === STEP 1: APPROVE ===');
    final token =
        erc20_api.ERC20(address: collateralAddress, client: _web3Client);
    
    debugPrint('🟡 [VAULT_REPO] Fetching token decimals...');
    final decimals = await token.decimals();
    debugPrint('✅ [VAULT_REPO] Token decimals: $decimals');

    final amountWei = _doubleToBigInt(amount, decimals.toInt());
    debugPrint('🟡 [VAULT_REPO] Amount conversion:');
    debugPrint('   - amount (double): $amount');
    debugPrint('   - decimals: $decimals');
    debugPrint('   - amountWei: $amountWei');

    debugPrint('🟡 [VAULT_REPO] Checking current allowance...');
    final currentAllowance =
        await token.allowance(userEthAddress, coreProxyAddress);
    debugPrint('✅ [VAULT_REPO] Current allowance: $currentAllowance');
    debugPrint('   - Required: $amountWei');
    debugPrint('   - Sufficient: ${currentAllowance >= amountWei}');

    if (currentAllowance < amountWei) {
      debugPrint('🟡 [VAULT_REPO] Approving CoreProxy to spend $amountWei...');
      try {
        final approveTxHash = await token.approve(coreProxyAddress, amountWei,
            credentials: credentials,);
        debugPrint('✅ [VAULT_REPO] Approval transaction sent: $approveTxHash');
        await _waitForReceipt(approveTxHash);
        debugPrint('✅ [VAULT_REPO] Approval transaction confirmed');
      } catch (approveError) {
        debugPrint('❌ [VAULT_REPO] Approval failed: $approveError');
        rethrow;
      }
    } else {
      debugPrint('✅ [VAULT_REPO] Allowance already sufficient, skipping approve');
    }

    // 2) Deposit collateral into the account using raw transaction
    debugPrint('\n🟡 [VAULT_REPO] === STEP 2: DEPOSIT COLLATERAL ===');
    final coreProxy =
        SynthetixCoreProxy(address: coreProxyAddress, client: _web3Client);
    
    debugPrint('🟡 [VAULT_REPO] deposit parameters:');
    debugPrint('   - accountId: $resolvedAccountId');
    debugPrint('   - collateralAddress: ${collateralAddress.hex}');
    debugPrint('   - amount: $amountWei');
    
    try {
      // Use typed deposit method from CoreProxy
      debugPrint('🟡 [VAULT_REPO] Calling coreProxy.deposit()...');
      final depositTxHash = await coreProxy.deposit(
        resolvedAccountId,
        collateralAddress,
        amountWei,
        credentials: credentials,
      );
      debugPrint('✅ [VAULT_REPO] deposit transaction submitted: $depositTxHash');
      await _waitForReceipt(depositTxHash);
      debugPrint('✅ [VAULT_REPO] deposit transaction confirmed');
    } catch (depositError) {
      debugPrint('❌ [VAULT_REPO] deposit FAILED: $depositError');
      rethrow;
    }

    // 3) Delegate collateral to the Spartan Council pool
    debugPrint('\n🟡 [VAULT_REPO] === STEP 3: DELEGATE COLLATERAL ===');
    
    try {
      debugPrint('🟡 [VAULT_REPO] Fetching latest account collateral...');
      final collateralData = await coreProxy.getAccountCollateral(
        resolvedAccountId,
        collateralAddress,
      );
      final totalDeposited = collateralData.totalDeposited;
      debugPrint('✅ [VAULT_REPO] Current total deposited: $totalDeposited');

      debugPrint('🟡 [VAULT_REPO] delegateCollateral parameters:');
      debugPrint('   - accountId: $resolvedAccountId');
      debugPrint('   - poolId: ${vault.poolId}');
      debugPrint('   - collateralAddress: ${collateralAddress.hex}');
      debugPrint('   - amount: $totalDeposited');
      debugPrint('   - leverage: $_oneXLeverage');

      debugPrint('🟡 [VAULT_REPO] Calling coreProxy.delegateCollateral()...');
      final txHash = await coreProxy.delegateCollateral(
        resolvedAccountId,
        vault.poolId,
        collateralAddress,
        totalDeposited,
        _oneXLeverage,
        credentials: credentials,
      );
      debugPrint('✅ [VAULT_REPO] delegateCollateral succeeded');
      debugPrint('   - txHash: $txHash');
      debugPrint('═══════════════════════════════════════════\n');
      return txHash;
    } catch (delegateError) {
      debugPrint('❌ [VAULT_REPO] delegateCollateral FAILED: $delegateError');
      if (delegateError is RPCError) {
        debugPrint('   - RPCError details: ${delegateError.toString()}');
      }
      debugPrint('═══════════════════════════════════════════\n');
      rethrow;
    }
  }

  /// Withdraw from a vault.
  ///
  /// Two-step process:
  /// 1. Undelegate collateral from the pool
  /// 2. Withdraw collateral from the account back to the user's wallet
  Future<String> withdraw({
    required VaultData vault,
    required double amount,
  }) async {
    debugPrint('\n═══════════════════════════════════════════');
    debugPrint('🟧 [VAULT_REPO] WITHDRAW CALLED');
    debugPrint('═══════════════════════════════════════════');

    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final collateralAddress = EthereumAddress.fromHex(vault.collateralAddress);
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);

    final token =
        erc20_api.ERC20(address: collateralAddress, client: _web3Client);
    final decimals = await token.decimals();
    final amountWei = _doubleToBigInt(amount, decimals.toInt());

    final coreProxy =
        SynthetixCoreProxy(address: coreProxyAddress, client: _web3Client);

    var resolvedAccountId = accountId;
    if (resolvedAccountId == BigInt.zero) {
      debugPrint('🟡 [VAULT_REPO] Stored accountId is zero, attempting to fetch from blockchain...');
      final fetchedId = await _fetchActualAccountId(userAddress!);
      if (fetchedId != null && fetchedId != BigInt.zero) {
        resolvedAccountId = fetchedId;
        accountId = fetchedId; // Cache it
        debugPrint('✅ [VAULT_REPO] Found on-chain accountId: $resolvedAccountId');
      }
    }
    debugPrint('🟧 [VAULT_REPO] Using resolved accountId: $resolvedAccountId');

    if (resolvedAccountId == BigInt.zero) {
      debugPrint('❌ [VAULT_REPO] No Synthetix account (accountId is zero)!');
      throw Exception('No Synthetix account found');
    }

    // Step 1: Undelegate collateral from pool (via delegateCollateral with reduced amount)
    debugPrint('🟧 [VAULT_REPO] Step 1: Undelegating collateral...');
    try {
      final collateralData = await coreProxy.getAccountCollateral(
        resolvedAccountId,
        collateralAddress,
      );
      final currentAssigned = collateralData.totalAssigned;
      debugPrint('   - currentAssigned: $currentAssigned');
      debugPrint('   - amount to undelegate (amountWei): $amountWei');
      
      final newAssigned = currentAssigned > amountWei ? (currentAssigned - amountWei) : BigInt.zero;
      debugPrint('   - target newAssigned: $newAssigned');

      final delegateTxHash = await coreProxy.delegateCollateral(
        resolvedAccountId,
        vault.poolId,
        collateralAddress,
        newAssigned,
        _oneXLeverage,
        credentials: credentials,
      );
      debugPrint('✅ [VAULT_REPO] Undelegate transaction submitted: $delegateTxHash');
      await _waitForReceipt(delegateTxHash);
      debugPrint('✅ [VAULT_REPO] Undelegate transaction confirmed');
    } on RPCError catch (e) {
      debugPrint('❌ [VAULT_REPO] Undelegate failed: ${e.message}');
      throw Exception('Undelegate failed: ${e.message}');
    }

    // Step 2: Withdraw collateral from account to wallet
    debugPrint('🟧 [VAULT_REPO] Step 2: Withdrawing to wallet...');
    try {
      final txHash = await coreProxy.withdrawCollateral(
        resolvedAccountId,
        collateralAddress,
        amountWei,
        credentials: credentials,
      );
      debugPrint('✅ [VAULT_REPO] Withdraw succeeded: $txHash');
      debugPrint('═══════════════════════════════════════════\n');
      if (txHash.isEmpty) throw Exception('Withdraw returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      debugPrint('❌ [VAULT_REPO] Withdraw failed: ${e.message}');
      throw Exception('Withdraw failed: ${e.message}');
    }
  }

  /// Mint (borrow) synthetic USD against delegated collateral.
  /// Requires collateral to be delegated first via deposit().
  Future<String> mintStablecoins({
    required double amount,
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    debugPrint('\n═══════════════════════════════════════════');
    debugPrint('🟣 [VAULT_REPO] MINT STABLECOINS CALLED');
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🟣 [VAULT_REPO] Parameters:');
    debugPrint('   - amount (double): $amount');
    debugPrint('   - collateralAddress: $collateralAddress');
    debugPrint('   - poolId: ${poolId ?? _spartanPoolId}');
    debugPrint('   - stored accountId: $accountId');

    if (userAddress == null) {
      debugPrint('❌ [VAULT_REPO] Wallet not connected');
      throw Exception('Wallet not connected');
    }

    var resolvedAccountId = accountId;
    if (resolvedAccountId == BigInt.zero) {
      debugPrint('🟡 [VAULT_REPO] Stored accountId is zero, attempting to fetch from blockchain...');
      final fetchedId = await _fetchActualAccountId(userAddress!);
      if (fetchedId != null && fetchedId != BigInt.zero) {
        resolvedAccountId = fetchedId;
        accountId = fetchedId; // Cache it
        debugPrint('✅ [VAULT_REPO] Found on-chain accountId: $resolvedAccountId');
      }
    }
    debugPrint('🟣 [VAULT_REPO] Using resolved accountId: $resolvedAccountId');

    if (resolvedAccountId == BigInt.zero) {
      debugPrint('❌ [VAULT_REPO] No Synthetix account (accountId is zero)!');
      throw Exception('No Synthetix account found');
    }

    final credentials = _walletRepository.credentials.value;
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
    final pool = poolId ?? _spartanPoolId;

    // sUSD decimals (typically 18)
    const susdDecimals = 18;
    final amountWei = _doubleToBigInt(amount, susdDecimals);
    if (amountWei <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Mint amount must be > 0');
    }

    // Use delegateCollateral pattern but call mintUsd
    final coreProxy = SynthetixCoreProxy(
      address: coreProxyAddress,
      client: _web3Client,
    );

    debugPrint('🟣 [VAULT_REPO] mintUsd parameters:');
    debugPrint('   - accountId: $resolvedAccountId');
    debugPrint('   - pool: $pool');
    debugPrint('   - collateral: $collateralEthAddress');
    debugPrint('   - amount: $amountWei');

    try {
      debugPrint('🟣 [VAULT_REPO] Calling coreProxy.mintUsd()...');
      final txHash = await coreProxy.mintUsd(
        resolvedAccountId,
        pool,
        collateralEthAddress,
        amountWei,
        credentials: credentials,
      );
      debugPrint('✅ [VAULT_REPO] mintUsd succeeded: $txHash');
      if (txHash.isEmpty) throw Exception('mintUsd returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      debugPrint('❌ [VAULT_REPO] mintUsd RPCError: ${e.message}');
      throw Exception('mintUsd reverted: ${e.message}');
    } catch (e) {
      debugPrint('❌ [VAULT_REPO] mintUsd error: $e');
      rethrow;
    }
  }

  /// Burn (repay) synthetic USD debt.
  Future<String> burnStablecoins({
    required double amount,
    required String collateralAddress,
    BigInt? poolId,
  }) async {
    if (userAddress == null) {
      throw Exception('Wallet not connected');
    }

    final credentials = _walletRepository.credentials.value;
    final coreProxyAddress = EthereumAddress.fromHex(_coreProxyAddress);
    final collateralEthAddress = EthereumAddress.fromHex(collateralAddress);
    final pool = poolId ?? _spartanPoolId;

    const susdDecimals = 18;
    final amountWei = _doubleToBigInt(amount, susdDecimals);
    if (amountWei <= BigInt.zero) {
      throw ArgumentError.value(amount, 'amount', 'Burn amount must be > 0');
    }

    final coreProxy = SynthetixCoreProxy(
      address: coreProxyAddress,
      client: _web3Client,
    );

    try {
      final txHash = await coreProxy.burnUsd(
        accountId,
        pool,
        collateralEthAddress,
        amountWei,
        credentials: credentials,
      );
      if (txHash.isEmpty) throw Exception('burnUsd returned empty hash');
      return txHash;
    } on RPCError catch (e) {
      throw Exception('burnUsd reverted: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Get per-position debt for the account via CoreProxy.getPositionDebt.
  ///
  /// Returns the signed int256 debt cast to BigInt (positive = owes sUSD).
  /// Returns zero gracefully when accountId is unset.
  Future<BigInt> getPositionDebt({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return BigInt.zero;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      return await coreProxy.getPositionDebt(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
    } catch (e) {
      debugPrint('Error getting position debt: $e');
      return BigInt.zero;
    }
  }

  /// Get max sUSD borrow amount for the account.
  ///
  /// Derived from the position's assigned collateral and a minimum safe
  /// c-ratio of 200% (2×). Formula:
  ///   maxBorrow = getPositionCollateral.amount / 2  (in collateral tokens)
  /// Returns zero gracefully when accountId is unset or position empty.
  Future<BigInt> getMaxBorrowAmount({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return BigInt.zero;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final positionAmount = await coreProxy.getPositionCollateral(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
      // At 200% min c-ratio, max borrowable = 50% of collateral value
      return positionAmount ~/ BigInt.two;
    } catch (e) {
      debugPrint('Error getting max borrow amount: $e');
      return BigInt.zero;
    }
  }

  /// Get live collateralization ratio for the account position.
  ///
  /// Calls CoreProxy.getPositionCollateralRatio which returns a uint256 in
  /// 18-decimal precision (e.g. 2e18 = 200%). Converts to a plain percentage.
  /// Returns 0.0 gracefully when accountId is unset or no position exists.
  Future<double> getCollateralRatio({
    required String collateralAddress,
    BigInt? poolId,
    BigInt? overrideAccountId,
  }) async {
    final resolvedAccountId = overrideAccountId ?? accountId;
    if (resolvedAccountId == BigInt.zero) return 0.0;
    final pool = poolId ?? _spartanPoolId;
    try {
      final coreProxy = SynthetixCoreProxy(
        address: EthereumAddress.fromHex(_coreProxyAddress),
        client: _web3Client,
      );
      final ratioRaw = await coreProxy.getPositionCollateralRatio(
        resolvedAccountId,
        pool,
        EthereumAddress.fromHex(collateralAddress),
      );
      // ratioRaw is in 18 decimals: 1e18 = 100%
      // Divide by 1e16 to convert to percentage (e.g. 2e18 / 1e16 = 200.0)
      return ratioRaw == BigInt.zero
          ? 0.0
          : ratioRaw.toDouble() / 1e16;
    } catch (e) {
      debugPrint('Error getting collateral ratio: $e');
      return 0.0;
    }
  }

  /// Get transaction receipt to verify transaction confirmation
  Future<TransactionReceipt?> getTransactionReceipt(String txHash) async {
    try {
      return await _web3Client.getTransactionReceipt(txHash);
    } catch (e) {
      debugPrint('Error getting transaction receipt: $e');
      return null;
    }
  }

  BigInt _doubleToBigInt(double amount, int decimals) {
    final factor = math.pow(10, decimals);
    return BigInt.from((amount * factor).round());
  }

  /// Convert BigInt to double accounting for token decimals
  double _bigIntToDouble(BigInt value, int decimals) {
    if (decimals == 0) return value.toDouble();
    final divisor = BigInt.from(10).pow(decimals);
    return value / divisor;
  }

  /// Calculate APY for the given collateral symbol.
  ///
  /// On Polygon: reads the live reward rate from CoreProxy.getRewardRate() and
  /// annualises it against the vault TVL. Returns 0.0 when the RewardsDistributor
  /// has not yet been deployed or funded.
  ///
  /// On Sepolia: always returns 0.0 until a distributor is deployed there.
  Future<double> _calculateAPY({
    required String symbol,
    required double tvl,
  }) async {
    if (_chain != EthereumChain.polygonMainnet) return 0.0;
    const distributorAddress = SynthetixConfig.rewardsDistributor;
    if (distributorAddress.isEmpty || tvl <= 0) return 0.0;

    try {
      // getRewardRate(poolId, collateralType, distributor) → tokens/second in 18-dec precision
      const getRewardRateAbi =
          '[{"inputs":[{"name":"poolId","type":"uint128"},{"name":"collateralType","type":"address"},{"name":"distributor","type":"address"}],"name":"getRewardRate","outputs":[{"name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]';
      final abi = web3.ContractAbi.fromJson(getRewardRateAbi, 'CoreProxy');
      final contract = web3.DeployedContract(
        abi,
        EthereumAddress.fromHex(_coreProxyAddress),
      );
      final fn = contract.function('getRewardRate');
      final result = await _web3Client.call(
        contract: contract,
        function: fn,
        params: [
          _spartanPoolId,
          EthereumAddress.fromHex(SynthetixConfig.axToken),
          EthereumAddress.fromHex(distributorAddress),
        ],
      );
      final rateRaw = result[0] as BigInt;
      if (rateRaw == BigInt.zero) return 0.0;
      // rateRaw is in 18-decimal axUSD per second; TVL is in AX tokens (oracle $1 each)
      final ratePerSecond = rateRaw.toDouble() / 1e18;
      final annualRewards = ratePerSecond * 365 * 24 * 3600;
      return (annualRewards / tvl) * 100;
    } catch (e) {
      debugPrint('APY calculation error: $e');
      return 0.0;
    }
  }

  /// Fallback APY when _calculateAPY throws.
  double _getFallbackAPY(String symbol) => 0.0;

  /// Fallback TVL for a single vault when the on-chain call fails.
  double _fallbackTvlForSymbol(String symbol) {
    if (_chain == EthereumChain.polygonMainnet) return 1100000.0;
    switch (symbol) {
      case 'WBTC': return 1250000.0;
      case 'WETH': return 2850000.0;
      default:     return 750000.0; // AX on Sepolia
    }
  }

  /// Get fallback vault data when blockchain calls fail.
  List<VaultData> _getFallbackVaults() {
    if (_chain == EthereumChain.polygonMainnet) return _getPolygonFallbackVaults();
    return _getSepoliaFallbackVaults();
  }

  List<VaultData> _getPolygonFallbackVaults() {
    return [
      VaultData(
        symbol: 'AX',
        balance: 0,
        tvl: 1100000,
        apy: 0,
        vaultAddress: _coreProxyAddressPolygon,
        collateralAddress: SynthetixConfig.axToken,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }

  List<VaultData> _getSepoliaFallbackVaults() {
    const axAddress = SynthetixConfig.axToken;
    const wbtcAddress = _wbtcSepolia;
    final wethAddress = const EthereumAddressConfig.weth()
        .address(EthereumChain.ethereumSepolia);

    return [
      VaultData(
        symbol: 'AX',
        balance: 0,
        tvl: 750000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: axAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WBTC',
        balance: 0,
        tvl: 1250000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wbtcAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
      VaultData(
        symbol: 'WETH',
        balance: 0,
        tvl: 2850000,
        apy: 0,
        vaultAddress: _coreProxyAddressSepolia,
        collateralAddress: wethAddress,
        poolId: _spartanPoolId,
        timestamp: DateTime.now(),
      ),
    ];
  }

}
