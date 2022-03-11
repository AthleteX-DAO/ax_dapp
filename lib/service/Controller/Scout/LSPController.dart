// ignore_for_file: non_constant_identifier_names
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import '../../../contracts/LongShortPair.g.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:http/http.dart';
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
  var aptAddress = ''.obs;
  final tokenClient =
      Web3Client("https://matic-mumbai.chainstacklabs.com", new Client());
  // Hard address listing of all Athletes

  LSPController();

  Future<void> mint() async {
    EthereumAddress address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    print("Attempting to MINT LSP");
    final theCredentials = controller.credentials;
    BigInt tokensToCreate =
        BigInt.from(createAmt.value) * BigInt.from(1000000000000000000);
    approve(genericLSP, address).then((value) async {
      String txString =
          await genericLSP.create(tokensToCreate, credentials: theCredentials);
      controller.updateTxString(txString); //Sends tx to controller
    });
  }

  Future<void> approve(
      LongShortPair genericLSP, EthereumAddress address) async {
    print("collaterall amount: ${await genericLSP.collateralPerPair()}");
    BigInt transferAmount = await genericLSP.collateralPerPair();
    BigInt amount = BigInt.from(createAmt.value) * transferAmount;
    print("[Console] Inside approve()");
    EthereumAddress axtaddress = EthereumAddress.fromHex(AXT.mumbaiAddress);
    Erc20 axt = Erc20(address: axtaddress, client: tokenClient);
    try {
      await axt.approve(address, amount, credentials: controller.credentials);
    } catch (e) {
      print("[Console] Could not approve: $e");
    }
  }

  Future<void> redeem() async {
    EthereumAddress address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    BigInt tokensToRedeem =
        BigInt.from(redeemAmt.value) * BigInt.from(1000000000000000000);
    genericLSP.redeem(tokensToRedeem, credentials: theCredentials);
  }

  void updateAptAddress(int athleteId) {
    if (AXT.idToAddress.containsKey(athleteId)) {
      aptAddress.value = AXT.idToAddress[athleteId] as String;
      print("[Console] Updated the aptAddress to $aptAddress");
    } else {
      aptAddress.value = '';
      throw Exception("Player id is not supported!");
    }

    update();
  }

  void updateCreateAmt(double newAmount) {
    createAmt.value = newAmount;
    print("creating lsps with collateral: $newAmount");
    update();
  }

  void updateRedeemAmt(double newAmount) {
    redeemAmt.value = newAmount;
    print("redeeming lsps with collateral: $newAmount");
    update();
  }

  Future<void> updateCollateralAmount() async {}
}
