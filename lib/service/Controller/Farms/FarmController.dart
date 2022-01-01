import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:get/get.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:web3dart/credentials.dart';

class FarmController extends GetxController {
  Controller controller = Get.find();
  var amount1 = 0.0.obs, amount2 = 0.0.obs;

  final EthereumAddress farmAddress = EthereumAddress.fromHex("hex");

  void deposit() async {
    
  }
}
