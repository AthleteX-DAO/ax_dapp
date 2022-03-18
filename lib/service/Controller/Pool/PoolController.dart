import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:web3dart/web3dart.dart';
import 'package:get/get.dart';

class PoolController extends GetxController {
  Controller controller = Get.find();
  late Dex _dex;
  late APTRouter _aptRouter;
  var address1 = "".obs, address2 = "".obs;
  var amount1 = 0.0.obs, amount2 = 0.0.obs;

  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
      DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch);

  final EthereumAddress routerTestnetAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");

  final EthereumAddress dexTestnetAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");

  PoolController() {
    
    // This is meant to switch as per the correct chain
    EthereumAddress routerAddress = routerTestnetAddress;
    EthereumAddress dexAddress = dexTestnetAddress;

    _dex = Dex(address: dexAddress, client: controller.client.value);
    _aptRouter =
        APTRouter(address: routerAddress, client: controller.client.value);
  }

  Future<void> addLiquidity() async {
    BigInt liquidity = BigInt.from(0);
    BigInt amountADesired = BigInt.from(amount1.value);
    BigInt amountBDesired = BigInt.from(amount2.value);

    BigInt amountAMin = BigInt.from(amount1.value - 2.0);
    BigInt amountBMin = BigInt.from(amount2.value - 2.0);

    EthereumAddress tokenAAddress = EthereumAddress.fromHex("$address1");
    EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");

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
    BigInt amountAMin = BigInt.from(amount1.value);
    BigInt amountBMin = BigInt.from(amount2.value);
    EthereumAddress tokenAAddress = EthereumAddress.fromHex("$address1");
    EthereumAddress tokenBAddress = EthereumAddress.fromHex("$address2");

    Credentials credentials = controller.credentials;
    EthereumAddress to = await controller.credentials.extractAddress();

    String txString = await _aptRouter.removeLiquidity(tokenAAddress,
        tokenBAddress, liquidity, amountAMin, amountBMin, to, twoMinuteDeadline,
        credentials: credentials);
  }

  Future<void> createPair() async {
    final credentials = controller.credentials;
    EthereumAddress tknA = EthereumAddress.fromHex("$address1");
    EthereumAddress tknB = EthereumAddress.fromHex("$address2");

    String txString =
        await _dex.createPair(tknA, tknB, credentials: credentials);
    controller.updateTxString(txString);
  }

  void updateTknAddress1(String newAddress) {
    address1.value = newAddress;
    update();
  }

  void updateTknAddress2(String newAddress) {
    address2.value = newAddress;
    update();
  }
}
