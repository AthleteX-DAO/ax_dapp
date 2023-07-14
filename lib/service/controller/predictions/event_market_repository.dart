import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/apt_factory_api.dart';
import 'package:ethereum_api/apt_router_api.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:ethereum_api/event_markets_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class EventMarketRepository {
  EventMarketRepository();

  Controller controller = Controller();
  late EventBasedPredictionMarket eventBasedPredictionMarket;
  late APTFactory aptFactory;
  late APTRouter aptRouter;
  RxString marketAddress = ''.obs;
  RxString address1 = ''.obs;
  RxString address2 = ''.obs;
  RxString yesAddress = ''.obs;
  RxString noAddress = ''.obs;
  RxDouble amount1 = 100.0.obs;
  RxDouble createAmt = 0.0.obs;
  RxInt decimalA = 1.obs;
  BigInt amountOutMin = BigInt.zero;
  Rx<BigInt> deadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  ).obs;

  String get eventMarketAddress => marketAddress.value;
  String get yesMarketAddress => yesAddress.value;
  String get noMarketAddress => noAddress.value;

  set eventMarketAddress(String newAddress) => marketAddress.value = newAddress;
  set yesMarketAddress(String newYesAddress) => address1.value = newYesAddress;
  set noMarketAddress(String newNoAddress) => address2.value = newNoAddress;

  Future<void> mint() async {
    final address = EthereumAddress.fromHex(marketAddress.value);
    final userCredentials = controller.credentials;
    final intCreate = BigInt.from(1 * 1e18);

    eventBasedPredictionMarket = EventBasedPredictionMarket(
      address: address,
      client: controller.client.value,
    );

    await eventBasedPredictionMarket.create(
      intCreate,
      credentials: userCredentials,
    );
  }

  Future<void> redeem() async {
    final address = EthereumAddress.fromHex(marketAddress.value);

    final userCredentials = controller.credentials;
    final redeemTokensAmnt = BigInt.from(1 * 1e18);

    eventBasedPredictionMarket = EventBasedPredictionMarket(
      address: address,
      client: controller.client.value,
    );

    await eventBasedPredictionMarket.redeem(
      redeemTokensAmnt,
      credentials: userCredentials,
    );
  }

  Future<void> approve(String contractAddress, double amount) async {
    const axt = Token.ax(EthereumChain.sxMainnet);
    final address = EthereumAddress.fromHex(axt.address);
    final contractToApprove = EthereumAddress.fromHex(contractAddress);
    final _amount = normalizeInput(amount);

    final athleteX = ERC20(address: address, client: controller.client.value);

    await athleteX.approve(
      contractToApprove,
      _amount,
      credentials: controller.credentials,
    );
  }

  Future<void> buy() async {
    final tokenAAddress = EthereumAddress.fromHex('$address1');
    final tokenBAddress = EthereumAddress.fromHex('$address2');
    final tokenAAmount = normalizeInput(amount1.value, decimal: decimalA.value);

    final path = <EthereumAddress>[tokenAAddress, tokenBAddress];
    final to = await controller.credentials.extractAddress();

    try {
      final transactionHash = await aptRouter.swapExactTokensForTokens(
        tokenAAmount,
        amountOutMin,
        path,
        to,
        deadline.value,
        credentials: controller.credentials,
      );
      controller.transactionHash = transactionHash;
    } catch (e) {
      controller.transactionHash = '';
      return Future.error(e);
    }
  }

  Future<void> sell() async {
    final tokenAAddress = EthereumAddress.fromHex('$address1');
    final tokenBAddress = EthereumAddress.fromHex('$address2');
    final tokenAAmount = normalizeInput(amount1.value, decimal: decimalA.value);

    final path = <EthereumAddress>[tokenAAddress, tokenBAddress];
    final to = await controller.credentials.extractAddress();

    try {
      final transactionHash = await aptRouter.swapExactTokensForTokens(
        tokenAAmount,
        amountOutMin,
        path,
        to,
        deadline.value,
        credentials: controller.credentials,
      );
      controller.transactionHash = transactionHash;
    } catch (e) {
      controller.transactionHash = '';
      return Future.error(e);
    }
  }
}
