import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/event_markets_api.dart';
import 'package:ethereum_api/tokens_api.dart';
import 'package:get/get.dart';
import 'package:http/src/client.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class EventMarketRepository {
  Controller controller = Controller();
  RxDouble createAmt = 0.0.obs;
  late HAWKSCELTICS hawksceltics;
  Web3Client tokenClient = Web3Client(
    'https://sx.technology.com',
    Client(),
  );

  Future<void> create() async {
    BigInt createTokensAmount;
    await hawksceltics.create(createTokensAmount, credentials: userCredentials);
  }

  Future<void> redeem() async {
    BigInt redeemTokensAmnt = BigInt.from(1);

    await hawksceltics.redeem(redeemTokensAmnt, credentials: userCredentials);
  }

  Future<void> approve(String axtAddress, double amount) async {
    const axt = Token.ax(EthereumChain.sxMainnet);
    final address = EthereumAddress.fromHex(axt.address);

    final _amount = normalizeInput(amount);
  }

  Future<void> buy() async {}

  Future<void> sell() async {}
}
