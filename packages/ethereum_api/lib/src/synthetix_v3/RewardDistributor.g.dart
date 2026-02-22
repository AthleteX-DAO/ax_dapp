// Generated code for RewardDistributor contract interface
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

// ABI mirrors the on-chain RewardsDistributor.sol exactly.
// Functions [0..4] are reads; [5] is the write.
final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[],"name":"payoutToken","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardedAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"precision","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"poolId","outputs":[{"internalType":"uint128","name":"","type":"uint128"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint128","name":"poolId","type":"uint128"},{"internalType":"address","name":"collateralType","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint64","name":"start","type":"uint64"},{"internalType":"uint32","name":"duration","type":"uint32"}],"name":"distributeRewards","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
    'RewardDistributor');

/// RewardDistributor contract interface for querying reward info
class RewardDistributor extends _i1.GeneratedContract {
  RewardDistributor({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// Returns the payout token address (axUSD on Polygon).
  Future<_i1.EthereumAddress> payoutToken({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[0];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as _i1.EthereumAddress;
  }

  /// Returns the total axUSD committed for rewards but not yet paid out.
  ///
  /// Increases on [distributeRewards], decreases as LPs claim.
  Future<BigInt> rewardedAmount({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[1];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the precision divisor (10^payoutTokenDecimals, i.e. 1e18 for axUSD).
  Future<BigInt> precision({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Returns the human-readable name set at construction.
  Future<String> name({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[3];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as String;
  }

  /// Returns the pool ID this distributor is bound to.
  Future<BigInt> poolId({
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[4];
    final params = <dynamic>[];
    final response = await read(function, params, atBlock);
    return response[0] as BigInt;
  }

  /// Schedules an axUSD reward distribution over [duration] seconds starting at [start].
  ///
  /// Only callable by the pool owner. The distributor must hold at least [amount]
  /// axUSD before this call, otherwise it reverts with NotEnoughBalance.
  Future<String> distributeRewards(
    BigInt poolId,
    _i1.EthereumAddress collateralType,
    BigInt amount,
    BigInt start,
    BigInt duration, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    final params = [poolId, collateralType, amount, start, duration];
    return write(credentials, transaction, function, params);
  }
}
