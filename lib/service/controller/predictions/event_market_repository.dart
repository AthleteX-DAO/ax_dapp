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
  late EventBasedPredictionMarket _eventBasedPredictionMarket;
  RxString marketAddress = ''.obs;
  RxDouble createAmt = 0.0.obs;
  Web3Client tokenClient = Web3Client(
    'https://sx.technology.com',
    Client(),
  );

  String get eventMarketAddress => marketAddress.value;

  set eventMarketAddress(String newAddress) => marketAddress.value = newAddress;

  Future<void> create() async {
    var address = EthereumAddress.fromHex(marketAddress.value);
    _eventBasedPredictionMarket =
        EventBasedPredictionMarket(address: address, client: tokenClient);
    final userCredentials = controller.credentials;
    final intCreate = (createAmt.value * 1e18) as BigInt;
    final createTokensAmount = BigInt.from(1);
    await _eventBasedPredictionMarket.create(
      intCreate,
      credentials: userCredentials,
    );
  }

  Future<void> redeem() async {
    final userCredentials = controller.credentials;
    final redeemTokensAmnt = BigInt.from(1);
    await _eventBasedPredictionMarket.redeem(redeemTokensAmnt,
        credentials: userCredentials);
  }

  Future<void> approve(String axtAddress, double amount) async {
    const axt = Token.ax(EthereumChain.sxMainnet);
    final address = EthereumAddress.fromHex(axt.address);

    final _amount = normalizeInput(amount);
  }

  Future<void> buy() async {
    print('You are now buying!');
  }

  Future<void> sell() async {
    print('You are now selling!');
  }
}
