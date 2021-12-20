import 'package:ae_dapp/contracts/StakingRewards.g.dart';

import '../Controller.dart';

class FarmBehavior {
  StakingRewards _rewards =
      StakingRewards(address: address, client: Controller.client);

  Future<String> stake(double a) {
    BigInt amount = BigInt.from(a);
    String txString = "";
    return _rewards.stake(amount, credentials: Controller.credentials);
  }

  Future<String> deposit(double a) {
    // Deposit behavior!
    Future<String> txString = Future.value();
    return txString;
  }
}
