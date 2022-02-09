// ignore_for_file: non_constant_identifier_names

import 'package:ax_dapp/service/Controller/APT.dart';
import 'package:get/get.dart';
import 'package:web3dart/credentials.dart';
import '../../../contracts/LongShortPair.g.dart';
import '../Controller.dart';

// --> Joe burrow
// --> Jamaar chase
// --> Matthew Stafford
// --> Cooper Kupp

class LSPController extends GetxController {
  Controller controller = Get.find();
  late LongShortPair genericLSP;
  var createAmt = 0.0.obs;
  var redeemAmt = 0.0.obs;
  // Hard address listing of all Athletes

  LSPController() {
    final theClient = controller.client.value;
    EthereumAddress address =
        EthereumAddress.fromHex("0x1145954422AeA78F0E11FE7E10F367405B029834");
    genericLSP = LongShortPair(address: address, client: theClient);
  }

  Future<void> mint() async {
    final theCredentials = controller.credentials;
    BigInt tokensToCreate = BigInt.from(createAmt.value);
    String txString =
        await genericLSP.create(tokensToCreate, credentials: theCredentials);
    controller.updateTxString(txString); //Sends tx to controller
  }

  Future<void> redeem() async {
    final theCredentials = controller.credentials;
    BigInt tokensToRedeem = BigInt.from(redeemAmt.value);
    genericLSP.redeem(tokensToRedeem, credentials: theCredentials);
  }

  void updateCreateAmt(double newAmount) {
    createAmt.value = newAmount;
    update();
  }

  void updateRedeemAmt(double newAmount) {
    redeemAmt.value = newAmount;
    update();
  }
}
