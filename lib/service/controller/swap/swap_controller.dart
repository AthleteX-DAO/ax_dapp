import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/apt_factory_api.dart';
import 'package:ethereum_api/apt_router_api.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:web3dart/web3dart.dart';

class SwapController extends GetxController {
  SwapController();
  Controller controller = Get.find();
  Rx<Token> activeTkn1 = Token.empty.obs, activeTkn2 = Token.empty.obs;
  RxString address1 = ''.obs, address2 = ''.obs;
  RxDouble amount1 = 0.0.obs, amount2 = 0.0.obs;
  RxDouble price = 0.0.obs;
  RxString routerAddress = ''.obs;
  RxString factoryAddress = ''.obs;

  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  );
  Rx<BigInt> deadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  ).obs;
  late APTFactory aptFactory;
  late APTRouter aptRouter;
  BigInt amountOutMin = BigInt.zero;
  double x = 0, y = 0, k = 0;
  RxInt decimalA = 0.obs;
  RxInt decimalB = 0.obs;

  Future<void> approve() async {
    var txString = '';
    final tokenAAddress = EthereumAddress.fromHex(address1.value);
    final routerMainnetAddress = EthereumAddress.fromHex(routerAddress.value);
    final tokenAAmount = normalizeInput(amount1.value, decimal: decimalA.value);
    final tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    try {
      txString = await tokenA.approve(
        routerMainnetAddress,
        tokenAAmount,
        credentials: controller.credentials,
      );
    } catch (e) {
      txString = '';
      controller.updateTxString(txString);
      return Future.error(e);
    }

    controller.updateTxString(txString);
  }

  // Actionables
  Future<void> swap() async {
    final tokenAAddress = EthereumAddress.fromHex('$address1');
    final tokenBAddress = EthereumAddress.fromHex('$address2');
    final tokenAAmount = normalizeInput(amount1.value, decimal: decimalA.value);

    final path = <EthereumAddress>[tokenAAddress, tokenBAddress];
    final to = await controller.credentials.extractAddress();
    var txString = '';

    try {
      txString = await aptRouter.swapExactTokensForTokens(
        tokenAAmount,
        amountOutMin,
        path,
        to,
        deadline.value,
        credentials: controller.credentials,
      );
      controller.updateTxString(txString);
    } catch (e) {
      txString = '';
      controller.updateTxString(txString);
      return Future.error(e);
    }
  }

  Future<void> createPair() async {
    String txString;
    final tknA = EthereumAddress.fromHex('$address1');
    final tknB = EthereumAddress.fromHex('$address2');
    try {
      txString = await aptFactory.createPair(
        tknA,
        tknB,
        credentials: controller.credentials,
      );
    } catch (_) {
      txString = await aptFactory.createPair(
        tknA,
        tknB,
        credentials: controller.credentials,
      );
    }

    controller.updateTxString(txString);
  }

  Future<void> swapforAX(String chainTokenAddress) async {
    final tknA = EthereumAddress.fromHex(address1.value);
    final amountIn = normalizeInput(amount1.value);
    final to = await controller.credentials.extractAddress();
    final path = <EthereumAddress>[
      tknA,
      EthereumAddress.fromHex(chainTokenAddress),
    ];
    final txString = await aptRouter.swapExactTokensForAVAX(
      amountIn,
      BigInt.zero,
      path,
      to,
      deadline.value,
      credentials: controller.credentials,
    );
    controller.updateTxString(txString);
  }

  Future<void> swapFromAX(String chainTokenAddress) async {
    final tknA = EthereumAddress.fromHex('$address1.value');

    final path = <EthereumAddress>[
      tknA,
      EthereumAddress.fromHex(chainTokenAddress),
    ];
    final to = await controller.credentials.extractAddress();
    final txString = await aptRouter.swapExactAVAXForTokens(
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

  void updateTopDecimals(int decimal) {
    decimalA.value = decimal;
    update();
  }

  void updateBottomDecimals(int decimal) {
    decimalB.value = decimal;
    update();
  }
}
