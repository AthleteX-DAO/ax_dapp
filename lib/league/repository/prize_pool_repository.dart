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
  Web3Client tokenClient = Web3Client('https://polygon-rpc.com/', Client());
  RxString aptUserAddress = ''.obs;
  RxString prizePoolAddress = ''.obs;

  String get admin => adminAddress.value;
  String get tokenAddress => aptUserAddress.value;
  String get contractAddress => prizePoolAddress.value;

  set admin(String address) => adminAddress.value = address;
  set contractAddress(String newAddress) => prizePoolAddress.value = newAddress;
  set tokenAddress(String pairAddress) => aptUserAddress.value = pairAddress;

  Future<void> joinLeague() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: tokenClient);
    final theCredentials = controller.credentials;
    final transactionHash =
        await prizePool.joinLeague(credentials: theCredentials);
    controller.transactionHash = transactionHash;
  }

  // Future<void> withdrawBeforePoolStarts() async {
  //   final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
  //   prizePool = Prizepool(address: poolAddress, client: tokenClient);
  //  prizePool;
  // }

  Future<void> createLeague() async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: tokenClient);
    final theCredentials = controller.credentials;
    final txnHash = await prizePool.joinLeague(credentials: theCredentials);
    controller.transactionHash = txnHash;
  }

  Future<void> distributePrize(String winnerAddress) async {
    final poolAddress = EthereumAddress.fromHex(prizePoolAddress.value);
    prizePool = Prizepool(address: poolAddress, client: tokenClient);
    final theCredentials = controller.credentials;
    final winner = EthereumAddress.fromHex(winnerAddress);
    final txnHash =
        await prizePool.distributePrize(winner, credentials: theCredentials);
    controller.transactionHash = txnHash;
  }
}
