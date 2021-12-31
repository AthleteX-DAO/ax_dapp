// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: non_constant_identifier_names

import 'package:web3dart/web3dart.dart' as _i1;import 'dart:typed_data' as _i2;final _contractAbi = _i1.ContractAbi.fromJson('[{"inputs":[{"internalType":"address","name":"_feeToSetter","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"token0","type":"address"},{"indexed":true,"internalType":"address","name":"token1","type":"address"},{"indexed":false,"internalType":"address","name":"pair","type":"address"},{"indexed":false,"internalType":"uint256","name":"","type":"uint256"}],"name":"PairCreated","type":"event"},{"constant":true,"inputs":[],"name":"INIT_CODE_PAIR_HASH","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"allPairs","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"allPairsLength","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"tokenA","type":"address"},{"internalType":"address","name":"tokenB","type":"address"}],"name":"createPair","outputs":[{"internalType":"address","name":"pair","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"feeTo","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"feeToSetter","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"}],"name":"getPair","outputs":[{"internalType":"address","name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"_feeTo","type":"address"}],"name":"setFeeTo","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"internalType":"address","name":"_feeToSetter","type":"address"}],"name":"setFeeToSetter","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"}]', 'Dex');class Dex extends _i1.GeneratedContract {Dex({required _i1.EthereumAddress address, required _i1.Web3Client client, int? chainId}) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i2.Uint8List> INIT_CODE_PAIR_HASH({_i1.BlockNum? atBlock}) async  { final function = self.function('INIT_CODE_PAIR_HASH');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i2.Uint8List); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> allPairs(BigInt , {_i1.BlockNum? atBlock}) async  { final function = self.function('allPairs');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> allPairsLength({_i1.BlockNum? atBlock}) async  { final function = self.function('allPairsLength');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> createPair(_i1.EthereumAddress tokenA, _i1.EthereumAddress tokenB, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('createPair');
final params = [tokenA, tokenB];
return  write(credentials, transaction, function, params); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> feeTo({_i1.BlockNum? atBlock}) async  { final function = self.function('feeTo');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> feeToSetter({_i1.BlockNum? atBlock}) async  { final function = self.function('feeToSetter');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> getPair(_i1.EthereumAddress tknA, _i1.EthereumAddress tknB, {_i1.BlockNum? atBlock}) async  { final function = self.function('getPair');
final params = [tknA, tknB];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> setFeeTo(_i1.EthereumAddress _feeTo, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('setFeeTo');
final params = [_feeTo];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> setFeeToSetter(_i1.EthereumAddress _feeToSetter, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('setFeeToSetter');
final params = [_feeToSetter];
return  write(credentials, transaction, function, params); } 
/// Returns a live stream of all PairCreated events emitted by this contract.
Stream<PairCreated> pairCreatedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('PairCreated');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  PairCreated(decoded); } ); } 
 }
class PairCreated {PairCreated(List<dynamic> response) : token0 = (response[0] as _i1.EthereumAddress), token1 = (response[1] as _i1.EthereumAddress), pair = (response[2] as _i1.EthereumAddress), var4 = (response[3] as BigInt);

final _i1.EthereumAddress token0;

final _i1.EthereumAddress token1;

final _i1.EthereumAddress pair;

final BigInt var4;

 }
