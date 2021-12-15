import 'package:ae_dapp/contracts/Dex.g.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:web3dart/contracts/erc20.dart';
import '../contracts/Dex.g.dart';
import '../contracts/APTRouter.g.dart';
import 'package:web3dart/web3dart.dart';

class DEXController extends Controller {
  final EthereumAddress _dexAddress =
      EthereumAddress.fromHex("0x778EF52b9c18dBCbc6B4A8a58B424eA6cEa5a551");
  final EthereumAddress routerAddress =
      EthereumAddress.fromHex("0x7EFc361e568d0038cfB200dF9d9Be27943e19017");
  late Dex _dex = Dex(address: dexAddress, client: client);
  late APTRouter _aptRouter = APTRouter(address: routerAddress, client: client);
  final BigInt twoMinuteDeadline = BigInt.from(
      DateTime.now().add(const Duration(minutes: 2)).millisecondsSinceEpoch);

  BigInt get amountOutMin => BigInt.one;
  BigInt get deadline => twoMinuteDeadline;
  EthereumAddress get dexAddress => _dexAddress;

  // Actionables
  Future<String> swap(
      EthereumAddress tokenAAddress,
      EthereumAddress tokenBAddress,
      BigInt tokenAAmount,
      BigInt tokenBAmount) async {
    Erc20 tokenA = Erc20(address: tokenAAddress, client: client);
    Erc20 tokenB = Erc20(address: tokenBAddress, client: client);

    BigInt amountOutMin = BigInt.from(0.00002);
    List<EthereumAddress> path = [tokenAAddress, tokenBAddress];
    EthereumAddress to = await credentials.extractAddress();
    String txString = "";
    // Deadline is two minutes from 'now'

    try {
      tokenA.approve(dexAddress, tokenAAmount, credentials: credentials);
      tokenB.approve(dexAddress, tokenBAmount, credentials: credentials);
      txString = await _aptRouter.swapExactTokensForTokens(
          tokenAAmount, amountOutMin, path, to, deadline,
          credentials: credentials);
    } catch (e) {
      print(
          "[Console] Unable to swap [$tokenAAddress, $tokenBAddress] tokens \n $e");
    }
    return txString;
  }

  Future<String> createPair(EthereumAddress tknA, EthereumAddress tknB) async {
    String txString;
    try {
      txString = await _dex.createPair(tknA, tknB, credentials: credentials);
    } catch (e) {
      print("[Console] Unable to create pair /n $e");
      txString = await _dex.createPair(tknA, tknB, credentials: credentials);
    }
    return txString;
  }

  Future<String> swapforAX(EthereumAddress tknA, BigInt amountIn) async {
    EthereumAddress to = await credentials.extractAddress();
    String txString;
    List<EthereumAddress> path = [tknA, axTokenAddr];
    txString = await _aptRouter.swapExactTokensForAVAX(
        amountIn, BigInt.one, path, to, deadline,
        credentials: credentials);
    return txString;
  }

  Future<String> swapFromAX(EthereumAddress tknA, BigInt amountIn) async {
    String txString;
    List<EthereumAddress> path = [tknA, axTokenAddr];
    EthereumAddress to = await credentials.extractAddress();
    txString = await _aptRouter.swapExactAVAXForTokens(
        amountOutMin, path, to, deadline,
        credentials: credentials);
    return txString;
  }
}
