import 'package:ax_dapp/contracts/APTRouter.g.dart';
import 'package:ax_dapp/contracts/Dex.g.dart';
import 'package:ax_dapp/service/Controller/AXT.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:get/get.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

class SwapController extends Controller {
  var activeTkn1 = Token("Empty Token", "ET").obs,
      activeTkn2 = Token("Empty Token", "ET").obs;
  var amount1 = 0.0.obs, amount2 = 0.0.obs;

  final EthereumAddress dexAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");
  final EthereumAddress routerAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
    // Deadline is two minutes from 'now'
    final BigInt twoMinuteDeadline = BigInt.from(
        DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch);
    var deadline = BigInt.zero.obs;
  late Dex _dex;
  late APTRouter _aptRouter;
  BigInt amountOutMin = BigInt.zero;

  SwapController() {
    _dex = Dex(address: dexAddress, client: client.value);
    _aptRouter =
        APTRouter(address: routerAddress, client: client.value);
  }

  // Actionables
  Future<void> swap() async {
    EthereumAddress tokenAAddress = activeTkn1.value.address;
    EthereumAddress tokenBAddress = activeTkn2.value.address;
    BigInt tokenAAmount = BigInt.from(activeTkn1.value.amount.value);
    BigInt tokenBAmount = BigInt.from(activeTkn2.value.amount.value);
    Erc20 tokenA = activeTkn1.value.erc20;
    Erc20 tokenB = activeTkn2.value.erc20;

    List<EthereumAddress> path = [tokenAAddress, tokenBAddress];
    EthereumAddress to = await credentials.extractAddress();
    String txString = "";

    try {
      tokenA.approve(dexAddress, tokenAAmount, credentials: credentials);
      tokenB.approve(dexAddress, tokenBAmount, credentials: credentials);
      txString = await _aptRouter.swapExactTokensForTokens(
          tokenAAmount, amountOutMin, path, to, deadline.value,
          credentials: credentials);
    } catch (e) {
      print(
          "[Console] Unable to swap [$tokenAAddress, $tokenBAddress] tokens \n $e");
    }
    updateTxString(txString);
  }

  Future<void> createPair(EthereumAddress tknA, EthereumAddress tknB) async {
    String txString;
    try {
      txString =
          await _dex.createPair(tknA, tknB, credentials: credentials);
    } catch (e) {
      print("[Console] Unable to create pair /n $e");
      txString =
          await _dex.createPair(tknA, tknB, credentials: credentials);
    }

    updateTxString(txString);
  }

  Future<void> swapforAX(EthereumAddress tknA, BigInt amountIn) async {
    EthereumAddress to = await credentials.extractAddress();
    List<EthereumAddress> path = [tknA, AXT.mumbaiAddress];
    String txString = await _aptRouter.swapExactTokensForAVAX(
        amountIn, BigInt.one, path, to, deadline.value,
        credentials: credentials);
    updateTxString(txString);
  }

  Future<void> swapFromAX(EthereumAddress tknA, BigInt amountIn) async {
    List<EthereumAddress> path = [tknA, AXT.mumbaiAddress];
    EthereumAddress to = await credentials.extractAddress();
    String txString = await _aptRouter.swapExactAVAXForTokens(
        amountOutMin, path, to, deadline.value,
        credentials: credentials);
    updateTxString(txString);
  }
}
