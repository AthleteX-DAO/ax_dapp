import 'package:web3dart/web3dart.dart';
import 'dart:convert';
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

  void getTokenMetrics() async {
    // Update circulating Supply, price, total supply in one call
    var theUrl = Uri.parse(
        "https://api.coingecko.com/api/v3/coins/athletex?localization=false&tickers=true");
    var tokenMetrics = await http
        .get(Uri.parse("https://api.coingecko.com/api/v3/coins/athletex"));
    var jsonTokenMetrics = json.decode(tokenMetrics.body);
    axPrice.value = jsonTokenMetrics['market_data']['current_price']['usd'];
    print("[Console] AX Price: $axPrice");
    update();
  }

  void addTokenToWallet() async {}
}
