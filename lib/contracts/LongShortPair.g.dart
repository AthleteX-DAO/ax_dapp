// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
    '[{"inputs":[{"internalType":"uint64","name":"_expirationTimestamp","type":"uint64"},{"internalType":"uint256","name":"_collateralPerPair","type":"uint256"},{"internalType":"bytes32","name":"_priceIdentifier","type":"bytes32"},{"internalType":"contract ExpandedIERC20","name":"_longToken","type":"address"},{"internalType":"contract ExpandedIERC20","name":"_shortToken","type":"address"},{"internalType":"contract IERC20","name":"_collateralToken","type":"address"},{"internalType":"contract FinderInterface","name":"_finder","type":"address"},{"internalType":"contract LongShortPairFinancialProductLibrary","name":"_financialProductLibrary","type":"address"},{"internalType":"bytes","name":"_customAncillaryData","type":"bytes"},{"internalType":"uint256","name":"_prepaidProposerReward","type":"uint256"},{"internalType":"address","name":"_timerAddress","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"caller","type":"address"}],"name":"ContractExpired","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":false,"internalType":"uint256","name":"colllateralReturned","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"longTokens","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"shortTokens","type":"uint256"}],"name":"PositionSettled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralUsed","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"tokensMinted","type":"uint256"}],"name":"TokensCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"sponsor","type":"address"},{"indexed":true,"internalType":"uint256","name":"collateralReturned","type":"uint256"},{"indexed":true,"internalType":"uint256","name":"tokensRedeemed","type":"uint256"}],"name":"TokensRedeemed","type":"event"},{"inputs":[],"name":"collateralPerPair","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"collateralToken","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"contractState","outputs":[{"internalType":"enum LongShortPair.ContractState","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"customAncillaryData","outputs":[{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"expirationTimestamp","outputs":[{"internalType":"uint64","name":"","type":"uint64"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"expiryPercentLong","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"expiryPrice","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"financialProductLibrary","outputs":[{"internalType":"contract LongShortPairFinancialProductLibrary","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"finder","outputs":[{"internalType":"contract FinderInterface","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCurrentTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"longToken","outputs":[{"internalType":"contract ExpandedIERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"prepaidProposerReward","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"priceIdentifier","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"time","type":"uint256"}],"name":"setCurrentTime","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"shortToken","outputs":[{"internalType":"contract ExpandedIERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"timerAddress","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokensToCreate","type":"uint256"}],"name":"create","outputs":[{"internalType":"uint256","name":"collateralUsed","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokensToRedeem","type":"uint256"}],"name":"redeem","outputs":[{"internalType":"uint256","name":"collateralReturned","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"longTokensToRedeem","type":"uint256"},{"internalType":"uint256","name":"shortTokensToRedeem","type":"uint256"}],"name":"settle","outputs":[{"internalType":"uint256","name":"collateralReturned","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"expire","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sponsor","type":"address"}],"name":"getPositionTokens","outputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]',
    'LongShortPair');

class LongShortPair extends _i1.GeneratedContract {
  LongShortPair(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(_i1.DeployedContract(_contractAbi, address), client, chainId);

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> collateralPerPair({_i1.BlockNum? atBlock}) async {
    final function = self.function('collateralPerPair');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> collateralToken({_i1.BlockNum? atBlock}) async {
    final function = self.function('collateralToken');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> contractState({_i1.BlockNum? atBlock}) async {
    final function = self.function('contractState');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> customAncillaryData({_i1.BlockNum? atBlock}) async {
    final function = self.function('customAncillaryData');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> expirationTimestamp({_i1.BlockNum? atBlock}) async {
    final function = self.function('expirationTimestamp');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> expiryPercentLong({_i1.BlockNum? atBlock}) async {
    final function = self.function('expiryPercentLong');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> expiryPrice({_i1.BlockNum? atBlock}) async {
    final function = self.function('expiryPrice');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> financialProductLibrary(
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('financialProductLibrary');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> longToken({_i1.BlockNum? atBlock}) async {
    final function = self.function('longToken');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> prepaidProposerReward({_i1.BlockNum? atBlock}) async {
    final function = self.function('prepaidProposerReward');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> priceIdentifier({_i1.BlockNum? atBlock}) async {
    final function = self.function('priceIdentifier');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i2.Uint8List);
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
  Future<_i1.EthereumAddress> shortToken({_i1.BlockNum? atBlock}) async {
    final function = self.function('shortToken');
    final params = [];
    final response = await read(function, params, atBlock);
    return (response[0] as _i1.EthereumAddress);
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

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> create(BigInt tokensToCreate,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('create');
    final params = [tokensToCreate];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> redeem(BigInt tokensToRedeem,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('redeem');
    final params = [tokensToRedeem];
    return write(credentials, transaction, function, params);
  }

  /// Uses financialProductLibrary to compute the redemption rate between long and short tokens.
  ///
  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> settle(BigInt longTokensToRedeem, BigInt shortTokensToRedeem,
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('settle');
    final params = [longTokensToRedeem, shortTokensToRedeem];
    return write(credentials, transaction, function, params);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> expire(
      {required _i1.Credentials credentials,
      _i1.Transaction? transaction}) async {
    final function = self.function('expire');
    final params = [];
    return write(credentials, transaction, function, params);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetPositionTokens> getPositionTokens(_i1.EthereumAddress sponsor,
      {_i1.BlockNum? atBlock}) async {
    final function = self.function('getPositionTokens');
    final params = [sponsor];
    final response = await read(function, params, atBlock);
    return GetPositionTokens(response);
  }

  /// Returns a live stream of all ContractExpired events emitted by this contract.
  Stream<ContractExpired> contractExpiredEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('ContractExpired');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return ContractExpired(decoded);
    });
  }

  /// Returns a live stream of all PositionSettled events emitted by this contract.
  Stream<PositionSettled> positionSettledEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('PositionSettled');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return PositionSettled(decoded);
    });
  }

  /// Returns a live stream of all TokensCreated events emitted by this contract.
  Stream<TokensCreated> tokensCreatedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TokensCreated');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TokensCreated(decoded);
    });
  }

  /// Returns a live stream of all TokensRedeemed events emitted by this contract.
  Stream<TokensRedeemed> tokensRedeemedEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('TokensRedeemed');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return TokensRedeemed(decoded);
    });
  }
}

class GetPositionTokens {
  GetPositionTokens(List<dynamic> response)
      : var1 = (response[0] as BigInt),
        var2 = (response[1] as BigInt);

  final BigInt var1;

  final BigInt var2;
}

class ContractExpired {
  ContractExpired(List<dynamic> response)
      : caller = (response[0] as _i1.EthereumAddress);

  final _i1.EthereumAddress caller;
}

class PositionSettled {
  PositionSettled(List<dynamic> response)
      : sponsor = (response[0] as _i1.EthereumAddress),
        colllateralReturned = (response[1] as BigInt),
        longTokens = (response[2] as BigInt),
        shortTokens = (response[3] as BigInt);

  final _i1.EthereumAddress sponsor;

  final BigInt colllateralReturned;

  final BigInt longTokens;

  final BigInt shortTokens;
}

class TokensCreated {
  TokensCreated(List<dynamic> response)
      : sponsor = (response[0] as _i1.EthereumAddress),
        collateralUsed = (response[1] as BigInt),
        tokensMinted = (response[2] as BigInt);

  final _i1.EthereumAddress sponsor;

  final BigInt collateralUsed;

  final BigInt tokensMinted;
}

class TokensRedeemed {
  TokensRedeemed(List<dynamic> response)
      : sponsor = (response[0] as _i1.EthereumAddress),
        collateralReturned = (response[1] as BigInt),
        tokensRedeemed = (response[2] as BigInt);

  final _i1.EthereumAddress sponsor;

  final BigInt collateralReturned;

  final BigInt tokensRedeemed;
}
