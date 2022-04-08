import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:get/get.dart';
import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:web3dart/web3dart.dart';

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
  final EthereumAddress dexAddress =
      EthereumAddress.fromHex("0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B");
  final EthereumAddress dexPolygonAddress =
      EthereumAddress.fromHex("0xe06DC83e310807BAcF2e1776925bC19Fa3659D78");
  final EthereumAddress routerAddress =
      EthereumAddress.fromHex("0xe78Bb28079B7a72C8d0e9f67c695E54B74556105");
  final EthereumAddress axtAddress =
      EthereumAddress.fromHex("0x5617604BA0a30E0ff1d2163aB94E50d8b6D0B0Df");
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
    _dex = Dex(address: dexAddress, client: controller.client.value);
    _aptRouter =
        APTRouter(address: routerAddress, client: controller.client.value);
  }

  Future<void> approve() async {
    print("Inside approve");
    String txString = "";
    EthereumAddress tokenAAddress = EthereumAddress.fromHex("$address1");
    //EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");
    BigInt tokenAAmount = BigInt.from(amount1.value);
    //BigInt tokenBAmount = BigInt.from(amount2.value);
    ERC20 tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    //ERC20 tokenB =
    //ERC20(address: tokenBAddress, client: controller.client.value);
    BigInt rate = BigInt.one;
    BigInt transferAmount = rate * tokenAAmount;
    try {
      print("Before approve");
      txString = await tokenA.approve(dexAddress, transferAmount,
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
    BigInt tokenAAmount =
        BigInt.from(amount1.value) * BigInt.one;

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
    BigInt amountIn = BigInt.from(amount1.value);
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
    price.value = amount1.value * amount2.value;
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
