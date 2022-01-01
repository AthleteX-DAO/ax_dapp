import 'package:ax_dapp/contracts/StakingRewards.g.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:get/get.dart';
import 'package:web3dart/credentials.dart';
import 'Controller.dart';

mixin FarmBehavior on Token {
  Controller controller = Get.find();


  Future<String> stake(double a) {
  EthereumAddress stakingAddress = EthereumAddress.fromHex(address.value);
  StakingRewards _rewards =
      StakingRewards(address: stakingAddress, client: controller.client.value);
    BigInt amount = BigInt.from(a);
    // ignore: unused_local_variable
    String txString = "";
    return _rewards.stake(amount, credentials: controller.credentials);
  }

  Future<String> deposit(double a) {
    // Deposit behavior!
    // ignore: null_argument_to_non_null_type
    Future<String> txString = Future.value();
    return txString;
  }
}
