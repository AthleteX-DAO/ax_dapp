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
  RxInt amount1 = 0.obs;
  RxInt decimalA = 0.obs;
  RxString routerAddress = ''.obs;

  int get entryAmount => amount1.value;
  String get admin => adminAddress.value;
  String get contractAddress => prizePoolAddress.value;
  int get tokenDecimals => decimalA.value;

  set tokenDecimals(int decimal) => decimalA.value = decimal;
  set entryAmount(int newAmount) => amount1.value = newAmount;
  set admin(String address) => adminAddress.value = address;
  set contractAddress(String newAddress) => prizePoolAddress.value = newAddress;

  Future<void> approve(String poolAddress) async {
    var txString = '';
    final tokenAAddress = EthereumAddress.fromHex('0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909');
    final prizePoolAddress = EthereumAddress.fromHex(poolAddress);
    final tokenAAmount = normalizeInput(amount1.value.toDouble(), decimal: decimalA.value);
    final tokenA =
        ERC20(address: tokenAAddress, client: controller.client.value);
    try {
      txString = await tokenA.approve(
        prizePoolAddress,
        tokenAAmount,
        credentials: controller.credentials,
      );
    } catch (e) {
      txString = '';
      controller.transactionHash = txString;
      return Future.error(e);
    }

    controller.transactionHash = txString;
  }

  Future<void> joinLeague() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: controller.client.value);
    final theCredentials = controller.credentials;
    final txnHash = await prizePool.joinLeague(credentials: theCredentials);
    controller.transactionHash = txnHash;
  }

  Future<void> withdrawBeforeLeagueStarts() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: controller.client.value);
    final theCredentials = controller.credentials;
    final txnHash =
        await prizePool.withdrawBeforeLeagueStarts(credentials: theCredentials);
    controller.transactionHash = txnHash;
  }

  Future<String> createLeague(
    int entryFeeAmount,
    int leagueStartTime,
    int leagueEndTime,
  ) async {
    const axTokenAddress = '0xd9Fd6e207a2196e1C3FEd919fCFE91482f705909';
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
