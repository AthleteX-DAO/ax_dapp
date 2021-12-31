import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:get/get.dart';
import 'package:web3dart/contracts/erc20.dart';
import '../../contracts/Dex.g.dart';
import '../../contracts/APTRouter.g.dart';
import 'package:web3dart/web3dart.dart';

import 'AXT.dart';

mixin SWAPBehavior on GetxController {
  Controller controller = Get.find();
  final EthereumAddress _dexAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");
  final EthereumAddress routerAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
  final AXT axt = AXT("AthleteX", "AX");
  late Dex _dex = Dex(address: dexAddress, client: controller.client);
  late APTRouter _aptRouter =
      APTRouter(address: routerAddress, client: controller.client);
  final BigInt twoMinuteDeadline = BigInt.from(
      DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch);

  BigInt get amountOutMin => BigInt.one;
  BigInt get deadline => twoMinuteDeadline;
  EthereumAddress get dexAddress => _dexAddress;

  // Actionables
  Future<void> swap(
      EthereumAddress tokenAAddress,
      EthereumAddress tokenBAddress,
      BigInt tokenAAmount,
      BigInt tokenBAmount) async {
    Erc20 tokenA = Erc20(address: tokenAAddress, client: controller.client);
    Erc20 tokenB = Erc20(address: tokenBAddress, client: controller.client);

    BigInt amountOutMin = BigInt.from(0.00002);
    List<EthereumAddress> path = [tokenAAddress, tokenBAddress];
    EthereumAddress to = await controller.credentials.extractAddress();
    String txString = "";
    // Deadline is two minutes from 'now'

    try {
      tokenA.approve(dexAddress, tokenAAmount,
          credentials: controller.credentials);
      tokenB.approve(dexAddress, tokenBAmount,
          credentials: controller.credentials);
      txString = await _aptRouter.swapExactTokensForTokens(
          tokenAAmount, amountOutMin, path, to, deadline,
          credentials: controller.credentials);
    } catch (e) {
      print(
          "[Console] Unable to swap [$tokenAAddress, $tokenBAddress] tokens \n $e");
    }
    controller.updateTxString(txString);
  }

  Future<void> createPair(EthereumAddress tknA, EthereumAddress tknB) async {
    String txString;
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

  Future<void> swapforAX(EthereumAddress tknA, BigInt amountIn) async {
    EthereumAddress to = await controller.credentials.extractAddress();
    List<EthereumAddress> path = [tknA, axt.mumbaiAddress];
    String txString = await _aptRouter.swapExactTokensForAVAX(
        amountIn, BigInt.one, path, to, deadline,
        credentials: controller.credentials);
    controller.updateTxString(txString);
  }

  Future<void> swapFromAX(EthereumAddress tknA, BigInt amountIn) async {
    List<EthereumAddress> path = [tknA, axt.mumbaiAddress];
    EthereumAddress to = await controller.credentials.extractAddress();
    String txString = await _aptRouter.swapExactAVAXForTokens(
        amountOutMin, path, to, deadline,
        credentials: controller.credentials);
    controller.updateTxString(txString);
  }
}
