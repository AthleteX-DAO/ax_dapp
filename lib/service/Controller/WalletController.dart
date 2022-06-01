import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:erc20/erc20.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'Controller.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class WalletController extends GetxController {
  late String axAddress;
  var axPrice = "-".obs;
  var axCirculation = "-".obs;
  var axTotalSupply = "-".obs;
  var yourBalance = "-".obs;
  var tokenPrice = 0.0.obs;
  Controller controller = Get.find();

  Future<void> getYourAxBalance() async {
    if (!_isWalletConnected()) return;
    if (controller.networkID.value == Controller.MAINNET_CHAIN_ID) {
      axAddress = AXT.polygonAddress;
    } else {
      axAddress = AXT.mumbaiAddress;
    }
    yourBalance.value = await getTokenBalance(axAddress);
    print("[Console] AX Balance: $yourBalance");
    update();
  }

  bool _isWalletConnected() {
    return controller.publicAddress.value.hex != EMPTY_WALLET_ID;
  }

  // Update token balance
  Future<String> getTokenBalance(String tokenAddress) async {
    var walletAddress = controller.publicAddress.value;
    late EthereumAddress tokenEthAddress;
    late String tokenBalance;
    var rpcUrl;
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value];
    }
    Web3Client rpcClient = Web3Client(rpcUrl, Client());
    tokenEthAddress = EthereumAddress.fromHex(tokenAddress);
    var ax = ERC20(address: tokenEthAddress, client: rpcClient);
    try {
      BigInt rawBalance = await ax.balanceOf(walletAddress);
      print("Raw Balance: $rawBalance");
      EtherAmount balanceInWei = EtherAmount.inWei(rawBalance);
      double balanceInEther = balanceInWei.getValueInUnit(EtherUnit.ether);
      tokenBalance = balanceInEther.toStringAsFixed(6);
    } catch (error) {
      tokenBalance = "0.0";
      print("[Console] Failed to retrieve the balance: $error");
    }
    update();
    return tokenBalance;
  }

  // Update circulating Supply, price, total supply in one call
  void getTokenMetrics() async {
    var coinGeckoUrl =
        Uri.parse("https://api.coingecko.com/api/v3/coins/athletex");
    var tokenMetrics = await http.get(coinGeckoUrl);
    if (tokenMetrics.statusCode == 200) {
      // if the request is successful -> get values
      var jsonTokenMetrics = json.decode(tokenMetrics.body);
      var ap = jsonTokenMetrics['market_data']['current_price']['usd'];
      if (ap != null) {
        axPrice.value = "$ap";
        tokenPrice.value = ap;
      }
      var ts = jsonTokenMetrics['market_data']['total_supply'];
      if (ts != null) {
        axTotalSupply.value = "$ts";
      }
      var ac = jsonTokenMetrics['market_data']['circulating_supply'];
      if (ac != 0) {
        axCirculation.value = "$ac";
      }
    } else {
      // if bad request -> throw Exception
      throw Exception('Failed to fetch the data from coingecko api');
    }

    print(
        "[Console] AX Price: $axPrice, AX TotalSupply: $axTotalSupply, AX Circulation: $axCirculation");
    update();
  }

  void buyAX() {
    // TODO: Update this when we need sushiswap connection
    // String axEth =
    //     "https://app.sushi.com/swap?inputCurrency=0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df&outputCurrency=0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";
    String axEthUniswap = "https://app.uniswap.org/#/swap?chain=polygon";

    launchUrl(Uri.parse(axEthUniswap));
  }

  Future<String> getTokenSymbol(String tokenAddress) async {
    EthereumAddress tokenEthAddress = EthereumAddress.fromHex(tokenAddress);
    String rpcUrl = "";
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value]!;
    } else {
      rpcUrl = "https://polygon-rpc.com";
    }
    Web3Client rpcClient = Web3Client(rpcUrl, Client());
    ERC20 token = ERC20(address: tokenEthAddress, client: rpcClient);
    return token.symbol();
  }

  void addTokenToWallet() async {}
}
