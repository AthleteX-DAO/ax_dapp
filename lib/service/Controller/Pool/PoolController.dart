import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/util/UserInputNorm.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';

class PoolController extends GetxController {
  Controller controller = Get.find();
  late Dex _factory;
  late APTRouter _aptRouter;
  var address1 = "".obs, address2 = "".obs;
  var amount1 = 0.0.obs, amount2 = 0.0.obs;
  final tokenClient = Web3Client("https://polygon-rpc.com", new Client());
  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
      DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch);

  final EthereumAddress routerTestnetAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
  final EthereumAddress dexTestnetAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");

  final EthereumAddress dexMainnetAddress =
      EthereumAddress.fromHex("0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B");
  final EthereumAddress routerMainnetAddress =
      EthereumAddress.fromHex("0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95");

  PoolController() {
    // This is meant to switch as per the correct chain
    EthereumAddress routerAddress = routerMainnetAddress;
    EthereumAddress dexAddress = dexMainnetAddress;

    _factory = Dex(address: dexAddress, client: controller.client.value);
    _aptRouter =
        APTRouter(address: routerAddress, client: controller.client.value);
  }

  Future<void> approve() async {
    print("[Console] Pool Controller -> Inside approve");
    String txStringA = "";
    String txStringB = "";
    BigInt tokenAAmount = normalizeInput(amount1.value);
    BigInt tokenBAmount = normalizeInput(amount2.value);

    EthereumAddress tokenAAddress = EthereumAddress.fromHex(address1.value);
    EthereumAddress tokenBAddress = EthereumAddress.fromHex(address2.value);

    ERC20 tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    ERC20 tokenB =
        ERC20(address: tokenBAddress, client: controller.client.value);

    BigInt transferAmountA = tokenAAmount;
    BigInt transferAmountB = tokenBAmount;
    print("Before try");
    try {
      print("[Console] Pool Controller -> Before approve");
      txStringA = await tokenA.approve(routerMainnetAddress, transferAmountA,
          credentials: controller.credentials);
      controller.updateTxString(txStringA);
      txStringB = await tokenB.approve(routerMainnetAddress, transferAmountB,
          credentials: controller.credentials);
      controller.updateTxString(txStringB);
      print("[Console] Pool Controller -> Approved");
    } catch (e) {
      print("[Console] Error happens");
      throw Exception(e.toString());
    }
  }

  Future<void> addLiquidity() async {
    BigInt amountADesired = normalizeInput(amount1.value);
    BigInt amountBDesired = normalizeInput(amount2.value);

    BigInt amountAMin = amountADesired * BigInt.from(0.5);
    BigInt amountBMin = amountADesired * BigInt.from(0.5);

    EthereumAddress tokenAAddress = EthereumAddress.fromHex(address1.value);
    EthereumAddress tokenBAddress = EthereumAddress.fromHex(address2.value);

    EthereumAddress to = await controller.credentials.extractAddress();
    Credentials credentials = controller.credentials;

    String txString = await _aptRouter.addLiquidity(
        tokenAAddress,
        tokenBAddress,
        amountADesired,
        amountBDesired,
        amountAMin,
        amountBMin,
        to,
        twoMinuteDeadline,
        credentials: credentials);

    controller.updateTxString(txString);
  }

  Future<void> removeLiquidity() async {
    BigInt liquidity = BigInt.from(0);
    BigInt amountAMin = normalizeInput(amount1.value);
    BigInt amountBMin = normalizeInput(amount2.value);
    EthereumAddress tokenAAddress =
        EthereumAddress.fromHex("${address1.value}");
    EthereumAddress tokenBAddress =
        EthereumAddress.fromHex("${address2.value}");

    Credentials credentials = controller.credentials;
    EthereumAddress to = await controller.credentials.extractAddress();

    String txString = await _aptRouter.removeLiquidity(tokenAAddress,
        tokenBAddress, liquidity, amountAMin, amountBMin, to, twoMinuteDeadline,
        credentials: credentials);
    controller.updateTxString(txString);
  }

  Future<void> createPair() async {
    final credentials = controller.credentials;
    EthereumAddress tknA = EthereumAddress.fromHex("$address1");
    EthereumAddress tknB = EthereumAddress.fromHex("$address2");

    String txString =
        await _factory.createPair(tknA, tknB, credentials: credentials);
    controller.updateTxString(txString);
  }

  void updateTknAddress1(String newAddress) {
    address1.value = newAddress;
    print("[Console] Pool Controller -> Address1: ${address1.value}");
    update();
  }

  void updateTknAddress2(String newAddress) {
    address2.value = newAddress;
    print("[Console] Pool Controller -> Address2: ${address2.value}");
    update();
  }

  void updateTopAmount(double newAmount) {
    amount1.value = newAmount;
    print("[Console] Pool Controller -> amount1: ${amount1.value}");
    update();
  }

  void updateBottomAmount(double newAmount) {
    amount2.value = newAmount;
    print("[Console] Pool Controller -> amount2: ${amount2.value}");
    update();
  }
}
