// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/util/user_input_info.dart';
import 'package:erc20/erc20.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class WalletController extends GetxController {
  late String axAddress;
  RxString axPrice = '-'.obs;
  RxString axCirculation = '-'.obs;
  RxString axTotalSupply = '-'.obs;
  RxString yourBalance = '-'.obs;
  RxDouble tokenPrice = 0.0.obs;
  Controller controller = Get.find();

  Future<void> getYourAxBalance() async {
    if (!_isWalletConnected()) return;
    if (controller.networkID.value == Controller.mainnetChainId) {
      axAddress = AXT.polygonAddress;
    } else {
      axAddress = AXT.mumbaiAddress;
    }
    yourBalance.value = await getTokenBalance(axAddress);
    update();
  }

  bool _isWalletConnected() {
    return controller.publicAddress.value.hex != kEmptyWalletId;
  }

  // Update token balance
  Future<String> getTokenBalance(String tokenAddress) async {
    final walletAddress = controller.publicAddress.value;
    late EthereumAddress tokenEthAddress;
    late String tokenBalance;
    String? rpcUrl;
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value];
    } else {
      throw ArgumentError('Unsupported RPC url');
    }
    final rpcClient = Web3Client(rpcUrl!, Client());
    tokenEthAddress = EthereumAddress.fromHex(tokenAddress);
    final ax = ERC20(address: tokenEthAddress, client: rpcClient);
    try {
      final rawBalance = await ax.balanceOf(walletAddress);
      final balanceInWei = EtherAmount.inWei(rawBalance);
      tokenBalance = balanceInWei.getValueInUnit(EtherUnit.ether).toString();
    } catch (error) {
      tokenBalance = '0.0';
    }
    update();
    return tokenBalance;
  }

  Future<UserInputInfo> getTokenBalanceAsInfo(
    String tokenAddress,
    int tokenDecimals,
  ) async {
    final walletAddress = controller.publicAddress.value;
    String? rpcUrl;
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value];
    } else {
      throw ArgumentError('Unsupported RPC url');
    }
    final rpcClient = Web3Client(rpcUrl!, Client());
    final token = ERC20(
      address: EthereumAddress.fromHex(tokenAddress),
      client: rpcClient,
    );
    var rawAmount = BigInt.zero;
    try {
      rawAmount = await token.balanceOf(walletAddress);
    } catch (_) {}
    update();
    final balance = UserInputInfo.fromBalance(
      rawAmount: rawAmount,
      decimals: tokenDecimals,
    );
    return balance;
  }

  // Update circulating Supply, price, total supply in one call
  Future<void> getTokenMetrics() async {
    final coinGeckoUrl =
        Uri.parse('https://api.coingecko.com/api/v3/coins/athletex');
    final tokenMetrics = await http.get(coinGeckoUrl);
    if (tokenMetrics.statusCode == 200) {
      // if the request is successful -> get values
      final jsonTokenMetrics = json.decode(tokenMetrics.body);
      final ap =
          jsonTokenMetrics['market_data']['current_price']['usd'] as double?;
      if (ap != null) {
        axPrice.value = '$ap';
        tokenPrice.value = ap;
      }
      final ts = jsonTokenMetrics['market_data']['total_supply'];
      if (ts != null) {
        axTotalSupply.value = '$ts';
      }
      final ac = jsonTokenMetrics['market_data']['circulating_supply'];
      if (ac != 0) {
        axCirculation.value = '$ac';
      }
    } else {
      // if bad request -> throw Exception
      throw Exception('Failed to fetch the data from coingecko api');
    }
    update();
  }

  void buyAX() {
    // TODO(KevinKamto): Update this when we need sushiswap connection
    // String axEth =
    //     "https://app.sushi.com/swap?inputCurrency=0x5617604ba0a30e0ff1d2163ab94e50d8b6d0b0df&outputCurrency=0x7ceb23fd6bc0add59e62ac25578270cff1b9f619";
    const axEthUniswap = 'https://app.uniswap.org/#/swap?chain=polygon';

    launchUrl(Uri.parse(axEthUniswap));
  }

  Future<String> getTokenSymbol(String tokenAddress) async {
    final tokenEthAddress = EthereumAddress.fromHex(tokenAddress);
    var rpcUrl = '';
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value]!;
    } else {
      rpcUrl = 'https://polygon-rpc.com';
    }
    final rpcClient = Web3Client(rpcUrl, Client());
    final token = ERC20(address: tokenEthAddress, client: rpcClient);
    return token.symbol();
  }

  Future<void> addTokenToWallet() async {}
}
