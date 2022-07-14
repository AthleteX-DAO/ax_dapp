// ignore_for_file: non_constant_identifier_names
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/util/UserInputNorm.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import '../../../contracts/LongShortPair.g.dart';
import 'package:erc20/erc20.dart';
import 'package:http/http.dart';
import '../../TokenList.dart';
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
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";
  final tokenClient = Web3Client("https://polygon-rpc.com", new Client());
  // Hard address listing of all Athletes

  LSPController();

  Future<void> mint() async {
    EthereumAddress address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    print("Attempting to MINT LSP");
    final theCredentials = controller.credentials;
    BigInt tokensToCreate = normalizeInput(createAmt.value);
    String txString =
        await genericLSP.create(tokensToCreate, credentials: theCredentials);
    controller.updateTxString(txString); //Sends tx to controller
  }

  Future<void> approve() async {
    EthereumAddress address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    print(
        "[Console] Collateral amount: ${await genericLSP.collateralPerPair()}");
    BigInt transferAmount = await genericLSP.collateralPerPair();
    BigInt amount = normalizeInput(createAmt.value) *
        transferAmount ~/
        BigInt.from(10).pow(18); // removes 18 zeros from collateralPerPair
    print("[Console] Inside approve()");
    EthereumAddress axtaddress = EthereumAddress.fromHex(AXT.polygonAddress);
    ERC20 axt = ERC20(address: axtaddress, client: tokenClient);
    try {
      await axt.approve(address, amount, credentials: controller.credentials);
    } catch (e) {
      print("[Console] Could not approve: $e");
    }
  }

  Future<bool> redeem() async {
    EthereumAddress address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    BigInt tokensToRedeem = normalizeInput(redeemAmt.value);
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
      print("[Console] Updated the aptAddress to $aptAddress");
    } else {
      aptAddress.value = '';
      // Comment this out for now to access the athlete page for other sports
      //throw Exception("Player id is not supported!");
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
