import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Farms/Farm.dart';
import 'package:ax_dapp/contracts/Pool.g.dart';
import 'package:get/get.dart';
import '../../TokenList.dart';

class FarmController extends GetxController {
  late Farm farm;
  var fundsToAddorRemove = 0.0.obs;
  var currentlyStaked = 0.0.obs;
  Controller controller = Get.find();
  var amount1 = 0.0.obs;
  var farmAddressString = "0x018a15dcd9ddb42718309611b0605aae06c51594";

  late Pool _pool;

  FarmController() {
    farm = new Farm("AX Farm", farmAddressString);
  }

  /// Used to get farm list from the api
  List<Farm> getFarms() {
    List<Farm> farms = [];
    for (dynamic ath in TokenList.namesList) {
      String stakingAddress = TokenList.idToAddress[ath[1]]![2];
      farms.add(Farm("${ath[0]} Long-Short APTs", stakingAddress));
    }
    return farms;
  }

  Future<void> stake() async {
    var stakeAmount = fundsToAddorRemove.value;
    String txString = await farm.stake(stakeAmount);
    controller.updateTxString(txString);
  }

  Future<void> unstake() async {
    var unstakeAmount = fundsToAddorRemove.value;
    String txString = await farm.unstake(unstakeAmount);
    controller.updateTxString(txString);
  }

  Future<void> claimRewards() async {
    String txString = await farm.claim();
    controller.updateTxString(txString);
  }

  /// This function is used to claim the rewards from the farm
  ///
  /// @param {BigInt} this is the amount of the staking
  /// @param {Farm} this is the information of the farm
  ///
  /// @return {String} the hash value of the transaction

}
