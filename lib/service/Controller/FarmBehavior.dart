import 'package:ax_dapp/contracts/StakingRewards.g.dart';

import 'Controller.dart';

class FarmBehavior {
  StakingRewards _rewards =
      StakingRewards(address: address, client: Controller.client);

  static var address;

  Future<String> stake(double a) {
    BigInt amount = BigInt.from(a);
    // ignore: unused_local_variable
    String txString = "";
    return _rewards.stake(amount, credentials: Controller.credentials);
  }

  Future<String> deposit(double a) {
    // Deposit behavior!
    // ignore: null_argument_to_non_null_type
    Future<String> txString = Future.value();
    return txString;
  }
}
