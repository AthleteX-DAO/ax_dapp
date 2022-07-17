import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class SwapController extends GetxController {
  SwapController() {
    _dex = Dex(address: dexMainnetAddress, client: controller.client.value);
    _aptRouter = APTRouter(
      address: routerMainnetAddress,
      client: controller.client.value,
    );
  }
  Controller controller = Get.find();
  Rx<Token> activeTkn1 = Token(
        'Empty Token',
        'ET',
        '0x0000000000000000000000000000000000000000',
      ).obs,
      activeTkn2 = Token(
        'Empty Token',
        'ET',
        '0x0000000000000000000000000000000000000000',
      ).obs;
  RxString address1 = ''.obs, address2 = ''.obs;
  RxDouble amount1 = 0.0.obs, amount2 = 0.0.obs;
  RxDouble price = 0.0.obs;
  final EthereumAddress routerTestnetAddress =
      EthereumAddress.fromHex('0x7EFc361e568d0038cfB200dF9d9Be27943e19017');
  final EthereumAddress dexTestnetAddress =
      EthereumAddress.fromHex('0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551');

  final EthereumAddress routerMainnetAddress =
      EthereumAddress.fromHex('0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95');
  final EthereumAddress dexMainnetAddress =
      EthereumAddress.fromHex('0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B');

  final axtAddress = EthereumAddress.fromHex(AXT.polygonAddress);
  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  );
  Rx<BigInt> deadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  ).obs;
  late Dex _dex;
  late APTRouter _aptRouter;
  BigInt amountOutMin = BigInt.zero;
  double x = 0, y = 0, k = 0;

  Future<void> approve() async {
    var txString = '';
    final tokenAAddress = EthereumAddress.fromHex(address1.value);
    //EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");
    final tokenAAmount = normalizeInput(amount1.value);
    //BigInt tokenBAmount = BigInt.from(amount2.value);
    final tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    //ERC20 tokenB =
    //ERC20(address: tokenBAddress, client: controller.client.value);
    try {
      txString = await tokenA.approve(
        routerMainnetAddress,
        tokenAAmount,
        credentials: controller.credentials,
      );
      //txString = await tokenB.approve(dexAddress, tokenBAmount,
      //  credentials: controller.credentials);
    } catch (_) {}

    controller.updateTxString(txString);
  }

  // Actionables
  Future<void> swap() async {
    final tokenAAddress = EthereumAddress.fromHex('$address1');
    final tokenBAddress = EthereumAddress.fromHex('$address2');
    final tokenAAmount = normalizeInput(amount1.value);

    final path = <EthereumAddress>[tokenAAddress, tokenBAddress];
    final to = await controller.credentials.extractAddress();
    var txString = '';

    try {
      txString = await _aptRouter.swapExactTokensForTokens(
        tokenAAmount,
        amountOutMin,
        path,
        to,
        deadline.value,
        credentials: controller.credentials,
      );
    } catch (_) {}
    controller.updateTxString(txString);
  }

  Future<void> createPair() async {
    String txString;
    final tknA = EthereumAddress.fromHex('$address1');
    final tknB = EthereumAddress.fromHex('$address2');
    try {
      txString = await _dex.createPair(
        tknA,
        tknB,
        credentials: controller.credentials,
      );
    } catch (_) {
      txString = await _dex.createPair(
        tknA,
        tknB,
        credentials: controller.credentials,
      );
    }

    controller.updateTxString(txString);
  }

  Future<void> swapforAX() async {
    final tknA = EthereumAddress.fromHex(address1.value);
    final amountIn = normalizeInput(amount1.value);
    final to = await controller.credentials.extractAddress();
    final path = <EthereumAddress>[tknA, axtAddress];
    final txString = await _aptRouter.swapExactTokensForAVAX(
      amountIn,
      BigInt.zero,
      path,
      to,
      deadline.value,
      credentials: controller.credentials,
    );
    controller.updateTxString(txString);
  }

  Future<void> swapFromAX() async {
    final tknA = EthereumAddress.fromHex('$address1.value');

    final path = <EthereumAddress>[tknA, axtAddress];
    final to = await controller.credentials.extractAddress();
    final txString = await _aptRouter.swapExactAVAXForTokens(
      amountOutMin,
      path,
      to,
      deadline.value,
      credentials: controller.credentials,
    );
    controller.updateTxString(txString);
  }

  void updateFromAmount(double newAmount) {
    amount1.value = newAmount;
    update();
  }

  void updateToAmount(double newAmount) {
    amount2.value = newAmount;
    update();
  }

  void updateFromAddress(String newAddress) {
    address1.value = newAddress;
    update();
  }

  void updateToAddress(String newAddress) {
    address2.value = newAddress;
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
