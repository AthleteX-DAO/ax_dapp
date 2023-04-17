import 'package:ax_dapp/service/controller/controller.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();
  String adminAddress = '';

  set admin(String address) => adminAddress;

  String get admin => adminAddress;

  Future<void> joinPrizePool() async {}
  Future<void> withdrawBeforePoolStarts() async {}
  Future<void> distributePrize(String winnerAddress) async {}
}
