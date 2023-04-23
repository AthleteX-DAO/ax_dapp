// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:ax_dapp/league/models/prize_pool_factory.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:ethereum_api/prizepool_api.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();

  late Prizepool prizePool;
  PrizePoolFactory prizePoolFactory = PrizePoolFactory();

  RxString adminAddress = ''.obs;
  RxString prizePoolAddress = ''.obs;
  RxDouble entryFeeAmount = 0.0.obs;
  RxInt decimalA = 0.obs;
  RxString routerAddress = ''.obs;

  double get entryAmount => entryFeeAmount.value;
  String get admin => adminAddress.value;
  String get contractAddress => prizePoolAddress.value;
  int get tokenDecimals => decimalA.value;

  set tokenDecimals(int decimal) => decimalA.value = decimal;
  set entryAmount(double newAmount) => entryFeeAmount.value = newAmount;
  set admin(String address) => adminAddress.value = address;
  set contractAddress(String newAddress) => prizePoolAddress.value = newAddress;

  final axTokenAddress = '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';

  Future<void> approve() async {
    var txnHash = '';
    final tokenAAddress = EthereumAddress.fromHex(axTokenAddress);
    final prizePoolAddress = EthereumAddress.fromHex(contractAddress);
    final tokenAAmount = normalizeInput(entryFeeAmount.value, decimal: decimalA.value);
    final tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    try {
      txnHash = await tokenA.approve(
        prizePoolAddress,
        tokenAAmount,
        credentials: controller.credentials,
      );
    } catch (e) {
      txnHash = '';
      controller.transactionHash = txnHash;
      return Future.error(e);
    }

    controller.transactionHash = txnHash;
  }

  Future<void> joinLeague() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: controller.client.value);
    final txnHash = await prizePool.joinLeague(credentials: controller.credentials);
    controller.transactionHash = txnHash;
  }

  Future<void> withdrawBeforeLeagueStarts() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: controller.client.value);
    final txnHash =
        await prizePool.withdrawBeforeLeagueStarts(credentials: controller.credentials);
    controller.transactionHash = txnHash;
  }

  Future<String> createLeague(
    int entryFeeAmount,
    int leagueStartTime,
    int leagueEndTime,
  ) async {
    final prizePoolAddress = await promiseToFuture<dynamic>(
      prizePoolFactory.createLeague(
        axTokenAddress,
        entryFeeAmount,
        leagueStartTime,
        leagueEndTime,
      ),
    );
    return prizePoolAddress.toString();
  }

  Future<void> distributePrize(String winnerAddress) async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: controller.client.value);
    final theCredentials = controller.credentials;
    final winner = EthereumAddress.fromHex(winnerAddress);
    final txnHash =
        await prizePool.distributePrize(winner, credentials: theCredentials);
    controller.transactionHash = txnHash;
  }
}
