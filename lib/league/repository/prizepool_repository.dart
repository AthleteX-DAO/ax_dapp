import 'package:ax_dapp/service/controller/controller.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ethereum_api/prizepool_api.dart';
import 'package:get/get.dart';

class PrizePoolRepository {
  PrizePoolRepository();

  Controller controller = Controller();
  String adminAddress = '';

  set admin(String address) => adminAddress;
  late Prizepool prizePool;
  String get admin => adminAddress;

  Future<void> joinPrizePool() async {
    prizePool.joinLeague();
  }

  //Future<void> withdrawBeforePoolStarts() async {
  //  prizePool.withdrawBeforeLeagueStarts();
  //}

  Future<void> distributePrize(String winnerAddress) async {
    prizePool.distributePrize();
  }
}

/// A Placeholder PrizePool.sol ABI
///
///
// class PrizePool {
//   /// The Prize Pool is where each league's funds are stored
//   PrizePool();

//   /// Join a newly created league
//   void joinLeague() {}

//   /// Withdraw from a league before it starts
//   void withdrawBeforeLeagueStarts() {}

//   /// Pay out the prize to the winner of the league
//   void distributePrize() {}
// }

