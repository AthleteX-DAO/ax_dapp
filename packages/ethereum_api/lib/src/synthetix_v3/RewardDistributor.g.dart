// Generated code for RewardDistributor contract interface
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[],"name":"payoutToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardsAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardedAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"precision","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint64","name":"start","type":"uint64"},{"internalType":"uint32","name":"duration","type":"uint32"}],"name":"distributeRewards","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RewardDistributor');

/// RewardDistributor contract interface for querying reward info
class RewardDistributor extends _i1.GeneratedContract {
  RewardDistributor({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// Returns the payout token address
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> payoutToken({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[0];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as _i1.EthereumAddress;
  }

  /// Returns the total rewards amount to be distributed
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> rewardsAmount({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[1];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the amount already rewarded
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> rewardedAmount({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the precision used for calculations
  ///
  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> precision({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[3];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Distribute rewards to a pool
  Future<String> distributeRewards(
    BigInt poolId,
    _i1.EthereumAddress collateralType,
    BigInt amount,
    BigInt start,
    BigInt duration, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    final params = [poolId, collateralType, amount, start, duration];
    return write(credentials, transaction, function, params);
  }
}
