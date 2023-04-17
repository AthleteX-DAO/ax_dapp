import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ethereum_api/prizepool_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();
  String adminAddress = '';

  set admin(String address) => adminAddress;
  late Prizepool prizePool;
  String get admin => adminAddress;
  Web3Client tokenClient = Web3Client('https://polygon-rpc.com/', Client());
  RxString aptUserAddress = ''.obs;
  String get tokenAddress => aptUserAddress.value;
  set tokenAddress(String pairAddress) => aptUserAddress.value = pairAddress;

  Future<void> joinLeague() async {
    final userAddress = EthereumAddress.fromHex(aptUserAddress.value);
    prizePool = Prizepool(address: userAddress, client: tokenClient);
    final theCredentials = controller.credentials;
    final transactionHash = await prizePool.joinLeague(credentials: theCredentials);
    controller.transactionHash = transactionHash;
  }

  //Future<void> withdrawBeforePoolStarts() async {
  //  prizePool.withdrawBeforeLeagueStarts();
  //}

  Future<void> distributePrize(String winnerAddress) async {
    prizePool.distributePrize();
  }
}