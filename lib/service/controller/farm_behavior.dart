import 'package:ax_dapp/contracts/StakingRewards.g.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:web3dart/credentials.dart';

mixin FarmBehavior on Token {
  Future<String> stake(double a) {
    final stakingAddress = EthereumAddress.fromHex(address.value);
    final _rewards = StakingRewards(
      address: stakingAddress,
      client: controller.client.value,
    );
    final amount = BigInt.from(a);
    // ignore: unused_local_variable
    return _rewards.stake(amount, credentials: controller.credentials);
  }

  Future<String> deposit(double a) {
    // Deposit behavior!
    // ignore: null_argument_to_non_null_type
    final txString = Future<String>.value();
    return txString;
  }
}
