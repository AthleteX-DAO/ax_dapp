// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;import 'dart:typed_data' as _i2;final _contractAbi = _i1.ContractAbi.fromJson('[{"inputs":[{"internalType":"address","name":"_rewardsToken","type":"address"},{"internalType":"address","name":"_stakingToken","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"reward","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"periodFinish","type":"uint256"}],"name":"RewardAdded","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"reward","type":"uint256"}],"name":"RewardPaid","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Staked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Withdrawn","type":"event"},{"inputs":[],"name":"lastUpdateTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"periodFinish","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardPerTokenStored","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardRate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"rewards","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardsDistribution","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardsToken","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"stakingToken","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"userRewardPerTokenPaid","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"lastTimeRewardApplicable","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"rewardPerToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"earned","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"stakeWithPermit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"stake","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"getReward","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"exit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"reward","type":"uint256"},{"internalType":"uint256","name":"rewardsDuration","type":"uint256"}],"name":"notifyRewardAmount","outputs":[],"stateMutability":"nonpayable","type":"function"}]', 'StakingRewards');class StakingRewards extends _i1.GeneratedContract {StakingRewards({required _i1.EthereumAddress address, required _i1.Web3Client client, int? chainId}) : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> lastUpdateTime({_i1.BlockNum? atBlock}) async  { final function = self.function('lastUpdateTime');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> periodFinish({_i1.BlockNum? atBlock}) async  { final function = self.function('periodFinish');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rewardPerTokenStored({_i1.BlockNum? atBlock}) async  { final function = self.function('rewardPerTokenStored');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rewardRate({_i1.BlockNum? atBlock}) async  { final function = self.function('rewardRate');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rewards(_i1.EthereumAddress address, {_i1.BlockNum? atBlock}) async  { final function = self.function('rewards');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> rewardsDistribution({_i1.BlockNum? atBlock}) async  { final function = self.function('rewardsDistribution');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> rewardsToken({_i1.BlockNum? atBlock}) async  { final function = self.function('rewardsToken');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<_i1.EthereumAddress> stakingToken({_i1.BlockNum? atBlock}) async  { final function = self.function('stakingToken');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as _i1.EthereumAddress); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> userRewardPerTokenPaid(_i1.EthereumAddress address, {_i1.BlockNum? atBlock}) async  { final function = self.function('userRewardPerTokenPaid');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> totalSupply({_i1.BlockNum? atBlock}) async  { final function = self.function('totalSupply');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> balanceOf(_i1.EthereumAddress account, {_i1.BlockNum? atBlock}) async  { final function = self.function('balanceOf');
final params = [account];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> lastTimeRewardApplicable({_i1.BlockNum? atBlock}) async  { final function = self.function('lastTimeRewardApplicable');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> rewardPerToken({_i1.BlockNum? atBlock}) async  { final function = self.function('rewardPerToken');
final params = [];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [atBlock] parameter can be used to view historical data. When
/// set, the function will be evaluated in the specified block. By default, the
/// latest on-chain block will be used.
Future<BigInt> earned(_i1.EthereumAddress account, {_i1.BlockNum? atBlock}) async  { final function = self.function('earned');
final params = [account];
final response =  await read(function, params, atBlock);
return  (response  [
0
] as BigInt); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> stakeWithPermit(BigInt amount, BigInt deadline, BigInt v, _i2.Uint8List r, _i2.Uint8List s, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('stakeWithPermit');
final params = [amount, deadline, v, r, s];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> stake(BigInt amount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('stake');
final params = [amount];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> withdraw(BigInt amount, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('withdraw');
final params = [amount];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> getReward({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('getReward');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> exit({required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('exit');
final params = [];
return  write(credentials, transaction, function, params); } 
/// The optional [transaction] parameter can be used to override parameters
/// like the gas price, nonce and max gas. The `data` and `to` fields will be
/// set by the contract.
Future<String> notifyRewardAmount(BigInt reward, BigInt rewardsDuration, {required _i1.Credentials credentials, _i1.Transaction? transaction}) async  { final function = self.function('notifyRewardAmount');
final params = [reward, rewardsDuration];
return  write(credentials, transaction, function, params); } 
/// Returns a live stream of all RewardAdded events emitted by this contract.
Stream<RewardAdded> rewardAddedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RewardAdded');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RewardAdded(decoded); } ); } 
/// Returns a live stream of all RewardPaid events emitted by this contract.
Stream<RewardPaid> rewardPaidEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('RewardPaid');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  RewardPaid(decoded); } ); } 
/// Returns a live stream of all Staked events emitted by this contract.
Stream<Staked> stakedEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Staked');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Staked(decoded); } ); } 
/// Returns a live stream of all Withdrawn events emitted by this contract.
Stream<Withdrawn> withdrawnEvents({_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) { final event = self.event('Withdrawn');
final filter = _i1.FilterOptions.events(contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
return  client.events(filter).map((_i1.FilterEvent result) { final decoded = event.decodeResults(result.topics!, result.data!);
return  Withdrawn(decoded); } ); } 
 }
class RewardAdded {RewardAdded(List<dynamic> response) : reward = (response[0] as BigInt), periodFinish = (response[1] as BigInt);

final BigInt reward;

final BigInt periodFinish;

 }
class RewardPaid {RewardPaid(List<dynamic> response) : user = (response[0] as _i1.EthereumAddress), reward = (response[1] as BigInt);

final _i1.EthereumAddress user;

final BigInt reward;

 }
class Staked {Staked(List<dynamic> response) : user = (response[0] as _i1.EthereumAddress), amount = (response[1] as BigInt);

final _i1.EthereumAddress user;

final BigInt amount;

 }
class Withdrawn {Withdrawn(List<dynamic> response) : user = (response[0] as _i1.EthereumAddress), amount = (response[1] as BigInt);

final _i1.EthereumAddress user;

final BigInt amount;

 }
