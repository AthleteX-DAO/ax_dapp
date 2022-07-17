// ignore_for_file: non_constant_identifier_names
import 'package:ax_dapp/contracts/LongShortPair.g.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:erc20/erc20.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

// --> Joe burrow
// --> Jamaar chase
// --> Matthew Stafford
// --> Cooper Kupp

class LSPController extends GetxController {
  // Hard address listing of all Athletes

  LSPController();
  Controller controller = Get.find();
  late LongShortPair genericLSP;
  RxDouble createAmt = 0.0.obs;
  RxDouble redeemAmt = 0.0.obs;
  RxString aptAddress = ''.obs;
  String mainRPCUrl = 'https://polygon-rpc.com';
  String testRPCUrl = 'https://matic-mumbai.chainstacklabs.com/';
  final tokenClient = Web3Client('https://polygon-rpc.com', Client());

  Future<void> mint() async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    final tokensToCreate = normalizeInput(createAmt.value);
    final txString =
        await genericLSP.create(tokensToCreate, credentials: theCredentials);
    controller.updateTxString(txString); //Sends tx to controller
  }

  Future<void> approve() async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final transferAmount = await genericLSP.collateralPerPair();
    final amount = normalizeInput(createAmt.value) *
        transferAmount ~/
        BigInt.from(10).pow(18); // removes 18 zeros from collateralPerPair
    final axtaddress = EthereumAddress.fromHex(AXT.polygonAddress);
    final axt = ERC20(address: axtaddress, client: tokenClient);
    try {
      await axt.approve(address, amount, credentials: controller.credentials);
    } catch (_) {}
  }

  Future<bool> redeem() async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    final tokensToRedeem = normalizeInput(redeemAmt.value);
    try {
      await genericLSP.redeem(tokensToRedeem, credentials: theCredentials);
      return true;
    } catch (_) {
      return false;
    }
  }

  void updateAptAddress(int athleteId) {
    if (TokenList.idToAddress.containsKey(athleteId)) {
      aptAddress.value = TokenList.idToAddress[athleteId]![0];
    } else {
      aptAddress.value = '';
      // Comment this out for now to access the athlete page for other sports
      // throw Exception("Player id is not supported!");
    }
    update();
  }

  void updateCreateAmt(double newAmount) {
    createAmt.value = newAmount;
    update();
  }

  void updateRedeemAmt(double newAmount) {
    redeemAmt.value = newAmount;
    update();
  }

  Future<void> updateCollateralAmount() async {}
}
