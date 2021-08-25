// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
import 'package:web3dart/web3dart.dart' as _i1;

class AthleteX extends _i1.GeneratedContract {
  AthleteX(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(
            _i1.DeployedContract(
                _i1.ContractAbi.fromJson(
                    '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burn","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"burnFrom","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
                    'AthleteX'),
                address),
            client,
            chainId);

  Future<BigInt> allowance(
      _i1.EthereumAddress owner, _i1.EthereumAddress spender) async {
    final function = self.function('allowance');
    final params = [owner, spender];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> approve(_i1.EthereumAddress spender, BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('approve');
    final params = [spender, amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<BigInt> balanceOf(_i1.EthereumAddress account) async {
    final function = self.function('balanceOf');
    final params = [account];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> burn(BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('burn');
    final params = [amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> burnFrom(_i1.EthereumAddress account, BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('burnFrom');
    final params = [account, amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<BigInt> decimals() async {
    final function = self.function('decimals');
    final params = [];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> decreaseAllowance(
      _i1.EthereumAddress spender, BigInt subtractedValue,
      {required _i1.Credentials credentials}) async {
    final function = self.function('decreaseAllowance');
    final params = [spender, subtractedValue];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> increaseAllowance(
      _i1.EthereumAddress spender, BigInt addedValue,
      {required _i1.Credentials credentials}) async {
    final function = self.function('increaseAllowance');
    final params = [spender, addedValue];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> name() async {
    final function = self.function('name');
    final params = [];
    final response = await read(function, params);
    return (response[0] as String);
  }

  Future<_i1.EthereumAddress> owner() async {
    final function = self.function('owner');
    final params = [];
    final response = await read(function, params);
    return (response[0] as _i1.EthereumAddress);
  }

  Future<String> renounceOwnership(
      {required _i1.Credentials credentials}) async {
    final function = self.function('renounceOwnership');
    final params = [];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> symbol() async {
    final function = self.function('symbol');
    final params = [];
    final response = await read(function, params);
    return (response[0] as String);
  }

  Future<BigInt> totalSupply() async {
    final function = self.function('totalSupply');
    final params = [];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }

  Future<String> transfer(_i1.EthereumAddress recipient, BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('transfer');
    final params = [recipient, amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> transferFrom(
      _i1.EthereumAddress sender, _i1.EthereumAddress recipient, BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('transferFrom');
    final params = [sender, recipient, amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> transferOwnership(_i1.EthereumAddress newOwner,
      {required _i1.Credentials credentials}) async {
    final function = self.function('transferOwnership');
    final params = [newOwner];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  Future<String> mint(_i1.EthereumAddress to, BigInt amount,
      {required _i1.Credentials credentials}) async {
    final function = self.function('mint');
    final params = [to, amount];
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: params);
    return write(credentials, transaction);
  }

  /// Returns a live stream of all Approval events emitted by this contract.
  Stream<Approval> approvalEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('Approval');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return Approval(decoded);
    });
  }

  /// Returns a live stream of all OwnershipTransferred events emitted by this contract.
  Stream<OwnershipTransferred> ownershipTransferredEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('OwnershipTransferred');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return OwnershipTransferred(decoded);
    });
  }

  /// Returns a live stream of all Transfer events emitted by this contract.
  Stream<Transfer> transferEvents(
      {_i1.BlockNum? fromBlock, _i1.BlockNum? toBlock}) {
    final event = self.event('Transfer');
    final filter = _i1.FilterOptions.events(
        contract: self, event: event, fromBlock: fromBlock, toBlock: toBlock);
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(result.topics!, result.data!);
      return Transfer(decoded);
    });
  }
}

class Approval {
  Approval(List<dynamic> response)
      : owner = (response[0] as _i1.EthereumAddress),
        spender = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt);

  final _i1.EthereumAddress owner;

  final _i1.EthereumAddress spender;

  final BigInt value;
}

class OwnershipTransferred {
  OwnershipTransferred(List<dynamic> response)
      : previousOwner = (response[0] as _i1.EthereumAddress),
        newOwner = (response[1] as _i1.EthereumAddress);

  final _i1.EthereumAddress previousOwner;

  final _i1.EthereumAddress newOwner;
}

class Transfer {
  Transfer(List<dynamic> response)
      : from = (response[0] as _i1.EthereumAddress),
        to = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt);

  final _i1.EthereumAddress from;

  final _i1.EthereumAddress to;

  final BigInt value;
}
