// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';

import 'package:ax_dapp/league/models/prize_pool_factory.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ethereum_api/prizepool_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();
  RxString adminAddress = ''.obs;

  late Prizepool prizePool;
  PrizePoolFactory prizePoolFactory = PrizePoolFactory();
  Web3Client contractClient = Web3Client('https://polygon-rpc.com/', Client());
  RxString prizePoolAddress = '0x8939C4029463007b9dA2EC58244eF15b63B04668'.obs;

  String get admin => adminAddress.value;
  String get contractAddress => prizePoolAddress.value;

  set admin(String address) => adminAddress.value = address;
  set contractAddress(String newAddress) => prizePoolAddress.value = newAddress;

  Future<void> joinLeague() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: contractClient);
    final theCredentials = controller.credentials;
    final txnHash = await prizePool.joinLeague(credentials: theCredentials);
    controller.transactionHash = txnHash;
  }

  Future<void> withdrawBeforeLeagueStarts() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: contractClient);
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
    print('this is the prize pool address: $prizePoolAddress');
    return prizePoolAddress.toString();
  }

  Future<void> distributePrize(String winnerAddress) async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: contractClient);
    final theCredentials = controller.credentials;
    final winner = EthereumAddress.fromHex(winnerAddress);
    final txnHash =
        await prizePool.distributePrize(winner, credentials: theCredentials);
    controller.transactionHash = txnHash;
  }
}
