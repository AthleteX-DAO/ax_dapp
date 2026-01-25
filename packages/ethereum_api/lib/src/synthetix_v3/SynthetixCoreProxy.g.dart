// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"}],"name":"getVaultCollateral","outputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"value","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"}],"name":"getVaultDebt","outputs":[{"internalType":"int256","name":"debt","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"}],"name":"getPoolConfiguration","outputs":[{"components":[{"internalType":"uint128","name":"marketId","type":"uint128"},{"internalType":"uint128","name":"weightD18","type":"uint128"},{"internalType":"int128","name":"maxDebtShareValueD18","type":"int128"}],"internalType":"struct MarketConfiguration.Data[]","name":"markets","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"accountId","type":"uint128"}],"name":"getAccountCollateral","outputs":[{"internalType":"uint256","name":"totalDeposited","type":"uint256"},{"internalType":"uint256","name":"totalAssigned","type":"uint256"},{"internalType":"uint256","name":"totalLocked","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"accountId","type":"uint128"},{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"}],"name":"getPositionCollateral","outputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"}],"name":"getVaultCollateralRatio","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"accountId","type":"uint128"},{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"leverage","type":"uint256"}],"name":"delegateCollateral","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint128","name":"accountId","type":"uint128"},{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"undelegateCollateral","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'SynthetixCoreProxy');

/// Synthetix V3 CoreProxy contract interface for vault operations
class SynthetixCoreProxy extends _i1.GeneratedContract {
  SynthetixCoreProxy({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// Returns the collateral amount and value for a vault
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetVaultCollateralResult> getVaultCollateral(
    BigInt poolId,
    _i1.EthereumAddress collateralType, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '36731394'));
    final params = [poolId, collateralType];
    final response = await read(function, params, atBlock);
    return GetVaultCollateralResult(
      amount: response[0] as BigInt,
      value: response[1] as BigInt,
    );
  }

  /// Returns the debt for a vault
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getVaultDebt(
    BigInt poolId,
    _i1.EthereumAddress collateralType, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'c035a4f0'));
    final params = [poolId, collateralType];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the pool configuration including connected markets
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getPoolConfiguration(
    BigInt poolId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '2faa3a7b'));
    final params = [poolId];
    final response = await read(function, params, atBlock);
    return response[0] as List<dynamic>;
  }

  /// Returns account collateral info
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetAccountCollateralResult> getAccountCollateral(
    BigInt accountId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'a0a6d21e'));
    final params = [accountId];
    final response = await read(function, params, atBlock);
    return GetAccountCollateralResult(
      totalDeposited: response[0] as BigInt,
      totalAssigned: response[1] as BigInt,
      totalLocked: response[2] as BigInt,
    );
  }

  /// Returns position collateral for an account
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getPositionCollateral(
    BigInt accountId,
    BigInt poolId,
    _i1.EthereumAddress collateralType, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'cf79b629'));
    final params = [accountId, poolId, collateralType];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the collateralization ratio for a vault
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getVaultCollateralRatio(
    BigInt poolId,
    _i1.EthereumAddress collateralType, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '6872bf61'));
    final params = [poolId, collateralType];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Delegates collateral to a pool for a specific account
  Future<String> delegateCollateral(
    BigInt accountId,
    BigInt poolId,
    _i1.EthereumAddress collateralType,
    BigInt amount,
    BigInt leverage, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'c3e2f2c0'));
    final params = [accountId, poolId, collateralType, amount, leverage];
    return write(credentials, transaction, function, params);
  }

  /// Undelegates collateral (withdraw) from a pool for a specific account
  Future<String> undelegateCollateral(
    BigInt accountId,
    BigInt poolId,
    _i1.EthereumAddress collateralType,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '10b22fa0'));
    final params = [accountId, poolId, collateralType, amount];
    return write(credentials, transaction, function, params);
  }
}

/// Result class for getVaultCollateral
class GetVaultCollateralResult {
  GetVaultCollateralResult({
    required this.amount,
    required this.value,
  });

  final BigInt amount;
  final BigInt value;
}

/// Result class for getAccountCollateral
class GetAccountCollateralResult {
  GetAccountCollateralResult({
    required this.totalDeposited,
    required this.totalAssigned,
    required this.totalLocked,
  });

  final BigInt totalDeposited;
  final BigInt totalAssigned;
  final BigInt totalLocked;
}
