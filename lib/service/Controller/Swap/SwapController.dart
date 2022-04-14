import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:ax_dapp/util/UserInputNorm.dart';
import 'package:get/get.dart';
import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:web3dart/web3dart.dart';

import 'AXT.dart';

class SwapController extends GetxController {
  Controller controller = Get.find();
  var activeTkn1 = Token(
              "Empty Token", "ET", "0x0000000000000000000000000000000000000000")
          .obs,
      activeTkn2 = Token(
              "Empty Token", "ET", "0x0000000000000000000000000000000000000000")
          .obs;
  var address1 = "".obs, address2 = "".obs;
  var amount1 = 0.0.obs, amount2 = 0.0.obs;
  var price = 0.0.obs;
  final EthereumAddress routerTestnetAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
  final EthereumAddress dexTestnetAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");

  final EthereumAddress routerMainnetAddress =
      EthereumAddress.fromHex("0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95");  
  final EthereumAddress dexMainnetAddress =
      EthereumAddress.fromHex("0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B");

  final axtAddress = EthereumAddress.fromHex(AXT.polygonAddress);
  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
      DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch);
  var deadline = BigInt.from(
          DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch)
      .obs;
  late Dex _dex;
  late APTRouter _aptRouter;
  BigInt amountOutMin = BigInt.zero;
  double x = 0.0, y = 0.0, k = 0.0;

  SwapController() {
    _dex = Dex(address: dexMainnetAddress, client: controller.client.value);
    _aptRouter = APTRouter(
        address: routerMainnetAddress, client: controller.client.value);
  }

  Future<void> approve() async {
    print("Inside approve");
    String txString = "";
    EthereumAddress tokenAAddress = EthereumAddress.fromHex(address1.value);
    //EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");
    BigInt tokenAAmount = normalizeInput(amount1.value);
    //BigInt tokenBAmount = BigInt.from(amount2.value);
    ERC20 tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    //ERC20 tokenB =
    //ERC20(address: tokenBAddress, client: controller.client.value);
    try {
      print("Before approve");
      txString = await tokenA.approve(routerMainnetAddress, tokenAAmount,
          credentials: controller.credentials);
      print("Approved");
      //txString = await tokenB.approve(dexAddress, tokenBAmount,
      //  credentials: controller.credentials);
    } catch (e) {
      print(e);
    }

    controller.updateTxString(txString);
  }

  // Actionables
  Future<void> swap() async {
    print(
        "Before the actual swap - print EVERYTHING: \n tknAAddr - $address1.value | tknBAddr = $address2.value \n tknAAmount - $amount1.value | tknBAmount - $amount2.value");

    EthereumAddress tokenAAddress = EthereumAddress.fromHex("$address1");
    EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");
    BigInt tokenAAmount = normalizeInput(amount1.value);

    List<EthereumAddress> path = [tokenAAddress, tokenBAddress];
    EthereumAddress to = await controller.credentials.extractAddress();
    String txString = "";

    try {
      txString = await _aptRouter.swapExactTokensForTokens(
          tokenAAmount, amountOutMin, path, to, deadline.value,
          credentials: controller.credentials);
    } catch (e) {
      print(
          "[Console] Unable to swap [$tokenAAddress, $tokenBAddress] tokens \n $e");
    }
    controller.updateTxString(txString);
  }

  Future<void> createPair() async {
    String txString;
    EthereumAddress tknA = EthereumAddress.fromHex("$address1");
    EthereumAddress tknB = EthereumAddress.fromHex("$address2");
    try {
      txString = await _dex.createPair(tknA, tknB,
          credentials: controller.credentials);
    } catch (e) {
      print("[Console] Unable to create pair /n $e");
      txString = await _dex.createPair(tknA, tknB,
          credentials: controller.credentials);
    }

    controller.updateTxString(txString);
  }

  Future<void> swapforAX() async {
    EthereumAddress tknA = EthereumAddress.fromHex("$address1.value");
    BigInt amountIn = normalizeInput(amount1.value);
    EthereumAddress to = await controller.credentials.extractAddress();
    List<EthereumAddress> path = [tknA, axtAddress];
    String txString = await _aptRouter.swapExactTokensForAVAX(
        amountIn, BigInt.one, path, to, deadline.value,
        credentials: controller.credentials);
    controller.updateTxString(txString);
  }

  Future<void> swapFromAX() async {
    EthereumAddress tknA = EthereumAddress.fromHex("$address1.value");

    List<EthereumAddress> path = [tknA, axtAddress];
    EthereumAddress to = await controller.credentials.extractAddress();
    String txString = await _aptRouter.swapExactAVAXForTokens(
        amountOutMin, path, to, deadline.value,
        credentials: controller.credentials);
    controller.updateTxString(txString);
  }

  void updateFromAmount(double newAmount) {
    amount1.value = newAmount;
    print("[Console] Swap Controller -> from amount1: ${amount1.value}");
    update();
  }

  void updateToAmount(double newAmount) {
    amount2.value = newAmount;
    print("[Console] Swap Controller -> to amount: ${amount2.value}");
    update();
  }

  void updateFromAddress(String newAddress) {
    address1.value = newAddress;
    print("[Console] Swap Controller -> from address: ${address1.value}");
    update();
  }

  void updateToAddress(String newAddress) {
    address2.value = newAddress;
    print("[Console] Swap Controller -> to address: ${address2.value}");
    update();
  }

  void updatePrice() {
    update();
  }

  void updateFromToken(Token tknFrom) {
    activeTkn1.value = tknFrom;
    update();
  }

  void updateToToken(Token tknTo) {
    activeTkn2.value = tknTo;
    update();
  }
}
