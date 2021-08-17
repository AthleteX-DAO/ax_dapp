import 'dart:core';
import 'package:web3dart/web3dart.dart' as _i1;

class StakingRewards extends _i1.GeneratedContract {
  StakingRewards(
      {required _i1.EthereumAddress address,
      required _i1.Web3Client client,
      int? chainId})
      : super(
            _i1.DeployedContract(
                _i1.ContractAbi.fromJson("jsonData", "StakingRewards"),
                address),
            client,
            chainId);

  /* ========== MUTATIVE FUNCTIONS ========== */

  Future<String> stake(BigInt amount, {required _i1.Credentials credentials}) {
    final function = self.function("stake");
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: [amount]);
    return write(credentials, transaction);
  }

  Future<String> withdraw(BigInt amount,
      {required _i1.Credentials credentials}) {
    final function = self.function('withdraw');
    final transaction = _i1.Transaction.callContract(
        contract: self, function: function, parameters: [amount]);
    return write(credentials, transaction);
  }

  /* ========== VIEWS ========== */

  Future<BigInt> totalSupply() async {
    final function = self.function("totalSupply");
    final params = [];
    final response = await read(function, params);

    return (response[0] as BigInt);
  }

  Future<BigInt> balanceOf(_i1.EthereumAddress account) async {
    final function = self.function('balanceOf');
    final params = [account];
    final response = await read(function, params);
    return (response[0] as BigInt);
  }
}
