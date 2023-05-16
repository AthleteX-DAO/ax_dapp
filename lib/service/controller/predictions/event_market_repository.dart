import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/apt_factory_api.dart';
import 'package:ethereum_api/apt_router_api.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:ethereum_api/event_markets_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  RxDouble amount1 = 1.0.obs;
  RxDouble createAmt = 0.0.obs;
  RxInt decimalA = 1.obs;
  BigInt amountOutMin = BigInt.zero;
  Rx<BigInt> deadline = BigInt.from(
    DateTime.now().add(const Duration(minutes: 5)).millisecondsSinceEpoch,
  ).obs;

  String get eventMarketAddress => marketAddress.value;
  set eventMarketAddress(String newAddress) => marketAddress.value = newAddress;

  Future<void> mint() async {
    print('minting event based prediction market');
    var address = EthereumAddress.fromHex(marketAddress.value);
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

  Future<void> approve(String axtAddress, double amount) async {
    // Defaults to sx chain's mainnet
    const axt = Token.ax(EthereumChain.sxMainnet);
    final address = EthereumAddress.fromHex(axt.address);
    final eventMarket = EthereumAddress.fromHex(marketAddress.value);
    final _amount = normalizeInput(amount);

    final AthleteX = ERC20(address: address, client: controller.client.value);

    await AthleteX.approve(
      eventMarket,
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
      controller.transactionHash = txString;
    } catch (e) {
      txString = '';
      controller.transactionHash = txString;
      return Future.error(e);
    }
  }

  Future<void> sell() async {
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
      controller.transactionHash = txString;
    } catch (e) {
      txString = '';
      controller.transactionHash = txString;
      return Future.error(e);
    }
  }
}
