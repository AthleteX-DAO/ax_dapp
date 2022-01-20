import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class WalletController extends GetxController {
  var axPrice = 0.0.obs;
  var axCirculation = 0.obs;
  var axTotalSupply = 0.obs;
  var yourBalance = 0.0.obs;

  void getYourAXBalance() async {
    update();
  }

  // Update circulating Supply, price, total supply in one call
  void getTokenMetrics() async {
    var theUrl = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/athletex?localization=false&tickers=true");
    var tokenMetrics = await http
        .get(Uri.parse("https://api.coingecko.com/api/v3/coins/athletex"));
    var jsonTokenMetrics = json.decode(tokenMetrics.body);
    axPrice.value = jsonTokenMetrics['market_data']['current_price']['usd'];
    print("[Console] AX Price: $axPrice");
    update();
  }

  // Update token balance
  void getTokenBalance() async {
    Controller controller = Get.find();
    var theClient = controller.client.value;
    var account = controller.publicAddress.value;
    var address = EthereumAddress.fromHex(AXT.polygonAddress);
    var ax = Erc20(address: address, client: theClient);
    BigInt rawBalance = await ax.balanceOf(account);
    yourBalance.value = rawBalance.toDouble();
    print("AX Blance: $yourBalance");
    update();
  }

  void addTokenToWallet() async {}
}
