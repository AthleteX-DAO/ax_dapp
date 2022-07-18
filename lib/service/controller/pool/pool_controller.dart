import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PoolController extends GetxController {
  PoolController() {
    // This is meant to switch as per the correct chain
    final routerAddress = routerMainnetAddress;
    final dexAddress = dexMainnetAddress;

    _factory = Dex(address: dexAddress, client: controller.client.value);
    _aptRouter =
        APTRouter(address: routerAddress, client: controller.client.value);
  }
  Controller controller = Get.find();
  late Dex _factory;
  late APTRouter _aptRouter;
  RxString address1 = ''.obs, address2 = ''.obs;
  String lpTokenAAddress = '';
  String lpTokenBAddress = '';
  String lpTokenPairAddress = '';
  double removePercentage = 0;
  RxDouble amount1 = 0.0.obs, amount2 = 0.0.obs;
  WalletController walletController = Get.find();
  final tokenClient = Web3Client('https://polygon-rpc.com', Client());
  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch,
  );

  final EthereumAddress routerTestnetAddress =
      EthereumAddress.fromHex('0x7EFc361e568d0038cfB200dF9d9Be27943e19017');
  final EthereumAddress dexTestnetAddress =
      EthereumAddress.fromHex('0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551');

  final EthereumAddress dexMainnetAddress =
      EthereumAddress.fromHex('0x8720DccfCd5687AfAE5F0BFb56ff664E6D8b385B');
  final EthereumAddress routerMainnetAddress =
      EthereumAddress.fromHex('0x15e4eb77713CD274472D95bDfcc7797F6a8C2D95');

  Future<void> approve() async {
    var txStringA = '';
    var txStringB = '';
    final tokenAAmount = normalizeInput(amount1.value);
    final tokenBAmount = normalizeInput(amount2.value);

    final tokenAAddress = EthereumAddress.fromHex(address1.value);
    final tokenBAddress = EthereumAddress.fromHex(address2.value);

    final tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    final tokenB =
        ERC20(address: tokenBAddress, client: controller.client.value);

    final transferAmountA = tokenAAmount;
    final transferAmountB = tokenBAmount;
    try {
      txStringA = await tokenA.approve(
        routerMainnetAddress,
        transferAmountA,
        credentials: controller.credentials,
      );
      controller.updateTxString(txStringA);
      txStringB = await tokenB.approve(
        routerMainnetAddress,
        transferAmountB,
        credentials: controller.credentials,
      );
      controller.updateTxString(txStringB);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addLiquidity() async {
    final amountADesired = normalizeInput(amount1.value);
    final amountBDesired = normalizeInput(amount2.value);

    final amountAMin = amountADesired * BigInt.from(0.5);
    final amountBMin = amountADesired * BigInt.from(0.5);

    final tokenAAddress = EthereumAddress.fromHex(address1.value);
    final tokenBAddress = EthereumAddress.fromHex(address2.value);

    final to = await controller.credentials.extractAddress();
    final credentials = controller.credentials;

    final txString = await _aptRouter.addLiquidity(
      tokenAAddress,
      tokenBAddress,
      amountADesired,
      amountBDesired,
      amountAMin,
      amountBMin,
      to,
      twoMinuteDeadline,
      credentials: credentials,
    );

    controller.updateTxString(txString);
  }

  Future<void> approveRemove() async {
    var txStringA = '';
    final lpTokenEthAddress = EthereumAddress.fromHex(lpTokenPairAddress);
    final lpToken =
        ERC20(address: lpTokenEthAddress, client: controller.client.value);
    final lpTokenBalance = normalizeInput(
      double.parse(
        await walletController.getTokenBalance(lpTokenPairAddress),
      ),
    );
    final approveAmount =
        (lpTokenBalance * BigInt.from(removePercentage)) ~/ BigInt.from(100);
    try {
      txStringA = await lpToken.approve(
        routerMainnetAddress,
        approveAmount,
        credentials: controller.credentials,
      );
      controller.updateTxString(txStringA);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeLiquidity() async {
    final lpTokenBalance = normalizeInput(
      double.parse(
        await walletController.getTokenBalance(lpTokenPairAddress),
      ),
    );
    final liquidity =
        (lpTokenBalance * BigInt.from(removePercentage)) ~/ BigInt.from(100);
    final amountAMin = BigInt.zero;
    final amountBMin = BigInt.zero;
    final tokenAAddress = EthereumAddress.fromHex(lpTokenAAddress);
    final tokenBAddress = EthereumAddress.fromHex(lpTokenBAddress);

    final credentials = controller.credentials;
    final to = await controller.credentials.extractAddress();

    final txString = await _aptRouter.removeLiquidity(
      tokenAAddress,
      tokenBAddress,
      liquidity,
      amountAMin,
      amountBMin,
      to,
      twoMinuteDeadline,
      credentials: credentials,
    );
    controller.updateTxString(txString);
  }

  Future<void> createPair() async {
    final credentials = controller.credentials;
    final tknA = EthereumAddress.fromHex('$address1');
    final tknB = EthereumAddress.fromHex('$address2');

    final txString =
        await _factory.createPair(tknA, tknB, credentials: credentials);
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

  void updateTopAmount(double newAmount) {
    amount1.value = newAmount;
    update();
  }

  void updateBottomAmount(double newAmount) {
    amount2.value = newAmount;
    update();
  }
}
