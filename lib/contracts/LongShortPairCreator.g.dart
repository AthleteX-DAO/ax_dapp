// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: unused_element

import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[{"internalType":"contract FinderInterface","name":"_finder","type":"address"},{"internalType":"contract TokenFactory","name":"_tokenFactory","type":"address"},{"internalType":"address","name":"_timer","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"longShortPair","type":"address"},{"indexed":true,"internalType":"address","name":"deployerAddress","type":"address"}],"name":"CreatedLongShortPair","type":"event"},{"inputs":[],"name":"finder","outputs":[{"internalType":"contract FinderInterface","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"name":"setCurrentTime","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"timerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"tokenFactory","outputs":[{"internalType":"contract TokenFactory","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint64","name":"expirationTimestamp","type":"uint64"},{"internalType":"uint256","name":"collateralPerPair","type":"uint256"},{"internalType":"bytes32","name":"priceIdentifier","type":"bytes32"},{"internalType":"string","name":"syntheticName","type":"string"},{"internalType":"string","name":"syntheticSymbol","type":"string"},{"internalType":"contract IERC20Standard","name":"collateralToken","type":"address"},{"internalType":"contract LongShortPairFinancialProductLibrary","name":"financialProductLibrary","type":"address"},{"internalType":"bytes","name":"customAncillaryData","type":"bytes"},{"internalType":"uint256","name":"prepaidProposerReward","type":"uint256"}],"name":"createLongShortPair","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract IERC20Standard","name":"_collateralToken","type":"address"}],"name":"_getSyntheticDecimals","outputs":[{"internalType":"uint8","name":"decimals","type":"uint8"}],"stateMutability":"view","type":"function"}]',
    'LongShortPairCreator');

class LongShortPairCreator extends _i1.GeneratedContract {
  LongShortPairCreator(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> finder({_i1.BlockNum? atBlock}) async {
    final function = self.function('finder');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

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
  Future<_i1.EthereumAddress> tokenFactory({_i1.BlockNum? atBlock}) async {
    final function = self.function('tokenFactory');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createLongShortPair(
      BigInt expirationTimestamp,
      BigInt collateralPerPair,
      _i2.Uint8List priceIdentifier,
      String syntheticName,
      String syntheticSymbol,
      _i1.EthereumAddress collateralToken,
      _i1.EthereumAddress financialProductLibrary,
      _i2.Uint8List customAncillaryData,
      BigInt prepaidProposerReward,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('createLongShortPair');
    final params = [
      expirationTimestamp,
      collateralPerPair,
      priceIdentifier,
      syntheticName,
      syntheticSymbol,
      collateralToken,
      financialProductLibrary,
      customAncillaryData,
      prepaidProposerReward
    ];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> _getSyntheticDecimals(_i1.EthereumAddress _collateralToken,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('_getSyntheticDecimals');
    final params = [_collateralToken];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// Returns a live stream of all CreatedLongShortPair events emitted by this contract.
  Stream<CreatedLongShortPair> createdLongShortPairEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('CreatedLongShortPair');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return CreatedLongShortPair(decoded);
    });
  }
}

class CreatedLongShortPair {
  CreatedLongShortPair(List<dynamic> response)
      : longShortPair = (response[0] as _i1.EthereumAddress),
        deployerAddress = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress longShortPair;

  final _i1.EthereumAddress deployerAddress;
}
