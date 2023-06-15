import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/truncate_double.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/apt_factory_api.dart';
import 'package:ethereum_api/apt_router_api.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class PoolRepository {
  PoolRepository();
  Controller controller = Controller();
  late APTFactory aptFactory;
  late APTRouter aptRouter;
  RxString routerAddress = ''.obs;
  RxString factoryAddress = ''.obs;
  RxString address1 = ''.obs;
  RxString address2 = ''.obs;
  String lpTokenAAddress = '';
  String lpTokenBAddress = '';
  String lpTokenPairAddress = '';
  double removePercentage = 0;
  RxDouble amount1 = 0.0.obs;
  RxDouble amount2 = 0.0.obs;
  RxInt decimalA = 0.obs;
  RxInt decimalB = 0.obs;

  String get tknAddress1 => address1.value;
  String get tknAddress2 => address2.value;
  double get topAmount => amount1.value;
  double get bottomAmount => amount2.value;
  int get topDecimals => decimalA.value;
  int get bottomDecimals => decimalB.value;

  set tknAddress1(String newAddress) => address1.value = newAddress;
  set tknAddress2(String newAddress) => address2.value = newAddress;
  set topAmount(double newAmount) => amount1.value = newAmount;
  set bottomAmount(double newAmount) => amount2.value = newAmount;
  set topDecimals(int decimal) => decimalA.value = decimal;
  set bottomDecimals(int decimal) => decimalB.value = decimal;

  // Deadline is two minutes from 'now'
  final BigInt twoMinuteDeadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch,
  );

  Future<void> approve() async {
    final routerMainnetAddress = EthereumAddress.fromHex(routerAddress.value);
    var txStringA = '';
    var txStringB = '';
    final tokenAAmount = normalizeInput(amount1.value, decimal: decimalA.value);
    final tokenBAmount = normalizeInput(amount2.value, decimal: decimalB.value);

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
      controller.transactionHash = txStringA;
      txStringB = await tokenB.approve(
        routerMainnetAddress,
        transferAmountB,
        credentials: controller.credentials,
      );
      controller.transactionHash = txStringB;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addLiquidity() async {
    final amountADesired =
        normalizeInput(amount1.value, decimal: decimalA.value);
    final amountBDesired =
        normalizeInput(amount2.value, decimal: decimalB.value);

    final amountAMin = amountADesired * BigInt.from(0.5);
    final amountBMin = amountADesired * BigInt.from(0.5);

    final tokenAAddress = EthereumAddress.fromHex(address1.value);
    final tokenBAddress = EthereumAddress.fromHex(address2.value);

    final to = await controller.credentials.extractAddress();
    final credentials = controller.credentials;

    final txString = await aptRouter.addLiquidity(
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

    controller.transactionHash = txString;
  }

  Future<void> approveRemove(
    Future<double?> Function(String address) getTokenBalanceHandler,
  ) async {
    final routerMainnetAddress = EthereumAddress.fromHex(routerAddress.value);
    var txStringA = '';
    final lpTokenEthAddress = EthereumAddress.fromHex(lpTokenPairAddress);
    final lpToken =
        ERC20(address: lpTokenEthAddress, client: controller.client.value);
    final tokenBalance = await getTokenBalanceHandler(lpTokenPairAddress);
    final truncatedTokenBalance =
        truncateToDecimalPlaces(value: tokenBalance ?? 0, fractionalDigits: 6);
    final lpTokenBalance = normalizeInput(truncatedTokenBalance);
    final approveAmount =
        (lpTokenBalance * BigInt.from(removePercentage)) ~/ BigInt.from(100);
    try {
      txStringA = await lpToken.approve(
        routerMainnetAddress,
        approveAmount,
        credentials: controller.credentials,
      );
      controller.transactionHash = txStringA;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeLiquidity(
    Future<double?> Function(String address) getTokenBalanceHandler,
  ) async {
    final tokenBalance = await getTokenBalanceHandler(lpTokenPairAddress);
    final truncatedTokenBalance =
        truncateToDecimalPlaces(value: tokenBalance ?? 0, fractionalDigits: 6);
    final lpTokenBalance = normalizeInput(truncatedTokenBalance);
    final liquidity =
        (lpTokenBalance * BigInt.from(removePercentage)) ~/ BigInt.from(100);
    final amountAMin = BigInt.zero;
    final amountBMin = BigInt.zero;
    final tokenAAddress = EthereumAddress.fromHex(lpTokenAAddress);
    final tokenBAddress = EthereumAddress.fromHex(lpTokenBAddress);

    final credentials = controller.credentials;
    final to = await controller.credentials.extractAddress();

    final txString = await aptRouter.removeLiquidity(
      tokenAAddress,
      tokenBAddress,
      liquidity,
      amountAMin,
      amountBMin,
      to,
      twoMinuteDeadline,
      credentials: credentials,
    );
    controller.transactionHash = txString;
  }

  Future<void> createPair() async {
    final credentials = controller.credentials;
    final tknA = EthereumAddress.fromHex('$address1');
    final tknB = EthereumAddress.fromHex('$address2');

    final txString =
        await aptFactory.createPair(tknA, tknB, credentials: credentials);
    controller.transactionHash = txString;
  }
}
