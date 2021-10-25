// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[{"internalType":"address","name":"_finderAddress","type":"address"},{"internalType":"address","name":"_tokenFactoryAddress","type":"address"},{"internalType":"address","name":"_timerAddress","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"configStoreAddress","type":"address"},{"indexed":true,"internalType":"address","name":"ownerAddress","type":"address"}],"name":"CreatedConfigStore","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"perpetualAddress","type":"address"},{"indexed":true,"internalType":"address","name":"deployerAddress","type":"address"}],"name":"CreatedPerpetual","type":"event"},{"inputs":[],"name":"getCurrentTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"name":"setCurrentTime","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"timerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tokenFactoryAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"address","name":"collateralAddress","type":"address"},{"internalType":"bytes32","name":"priceFeedIdentifier","type":"bytes32"},{"internalType":"bytes32","name":"fundingRateIdentifier","type":"bytes32"},{"internalType":"string","name":"syntheticName","type":"string"},{"internalType":"string","name":"syntheticSymbol","type":"string"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"collateralRequirement","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"disputeBondPercentage","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"sponsorDisputeRewardPercentage","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"disputerDisputeRewardPercentage","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"minSponsorTokens","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"tokenScaling","type":"tuple"},{"internalType":"uint256","name":"withdrawalLiveness","type":"uint256"},{"internalType":"uint256","name":"liquidationLiveness","type":"uint256"}],"internalType":"struct PerpetualCreator.Params","name":"params","type":"tuple"},{"components":[{"internalType":"uint256","name":"timelockLiveness","type":"uint256"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"rewardRatePerSecond","type":"tuple"},{"components":[{"internalType":"uint256","name":"rawValue","type":"uint256"}],"internalType":"struct FixedPoint.Unsigned","name":"proposerBondPercentage","type":"tuple"},{"components":[{"internalType":"int256","name":"rawValue","type":"int256"}],"internalType":"struct FixedPoint.Signed","name":"maxFundingRate","type":"tuple"},{"components":[{"internalType":"int256","name":"rawValue","type":"int256"}],"internalType":"struct FixedPoint.Signed","name":"minFundingRate","type":"tuple"},{"internalType":"uint256","name":"proposalTimePastLimit","type":"uint256"}],"internalType":"struct ConfigStoreInterface.ConfigSettings","name":"configSettings","type":"tuple"}],"name":"createPerpetual","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_collateralAddress","type":"address"}],"name":"_getSyntheticDecimals","outputs":[{"internalType":"uint8","name":"decimals","type":"uint8"}],"stateMutability":"view","type":"function"}]',
    'PerpetualCreator');

class PerpetualCreator extends _i1.GeneratedContract {
  PerpetualCreator(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getCurrentTime({_i1.BlockNum? atBlock}) async {
    final function = self.function('getCurrentTime');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// Will revert if not running in test mode.
  ///
  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> setCurrentTime(BigInt time,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('setCurrentTime');
    final params = [time];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> timerAddress({_i1.BlockNum? atBlock}) async {
    final function = self.function('timerAddress');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> tokenFactoryAddress(
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('tokenFactoryAddress');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createPerpetual(dynamic param, dynamic configSettings,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('createPerpetual');
    final params = [param, configSettings];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> _getSyntheticDecimals(_i1.EthereumAddress _collateralAddress,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('_getSyntheticDecimals');
    final params = [_collateralAddress];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// Returns a live stream of all CreatedConfigStore events emitted by this contract.
  Stream<CreatedConfigStore> createdConfigStoreEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CreatedConfigStore');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CreatedConfigStore(decoded);
    });
  }

  /// Returns a live stream of all CreatedPerpetual events emitted by this contract.
  Stream<CreatedPerpetual> createdPerpetualEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CreatedPerpetual');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CreatedPerpetual(decoded);
    });
  }
}

class CreatedConfigStore {
  CreatedConfigStore(List<dynamic> response)
      : configStoreAddress = (response[0] as _i1.EthereumAddress),
        ownerAddress = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress configStoreAddress;

  final _i1.EthereumAddress ownerAddress;
}

class CreatedPerpetual {
  CreatedPerpetual(List<dynamic> response)
      : perpetualAddress = (response[0] as _i1.EthereumAddress),
        deployerAddress = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress perpetualAddress;

  final _i1.EthereumAddress deployerAddress;
}
