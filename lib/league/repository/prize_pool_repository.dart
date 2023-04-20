import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ethereum_api/prizepool_api.dart';
import 'package:get/get.dart';
import '../models/PrizePoolFactory.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();
  RxString adminAddress = ''.obs;

  late Prizepool prizePool;
  PrizePoolFactory prizePoolFactory = PrizePoolFactory();
  Web3Client contractClient = Web3Client('https://polygon-rpc.com/', Client());
  RxString prizePoolAddress = ''.obs;

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

  Future<void> createLeague(int entryFeeAmount, int leagueStartTime, int leagueEndTime) async {
    final axToken = Token.ax;
    final txnHash = prizePoolFactory.createLeague(axToken, entryFeeAmount, leagueStartTime, leagueEndTime);
    controller.transactionHash = txnHash;
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
