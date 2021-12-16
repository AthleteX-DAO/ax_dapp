import 'dart:math';

import 'package:web3dart/web3dart.dart';
import 'package:ae_dapp/service/Controller/Controller.dart';
import 'package:ae_dapp/contracts/StakingRewards.g.dart';
import 'package:ae_dapp/contracts/AthleteX.g.dart';

class StakingController extends Controller {

    // Defined Staking
  EthereumAddress stakingAddr =
      EthereumAddress.fromHex("0x9CCf92AF15B81ba843a7dF58693E7125196F30aB");
// Defined AthelteX
  final EthereumAddress axTokenAddr =
      EthereumAddress.fromHex("0x8c086885624c5b823cc6fca7bff54c454d6b5239");

    // Contract Instantiation
  late StakingRewards _stakingRewards = StakingRewards(address: stakingAddr, client: client);
  late AthleteX _athleteX = AthleteX(address: axTokenAddr, client: client);

    // Viewables
  Stream<BigInt> availableBalance() async* {
    EthereumAddress account = await credentials.extractAddress();
    while (true) {
      BigInt returnValue = await _athleteX.balanceOf(account);
      yield returnValue;
    }
  }

  Stream<String> stakedAX() async* {
    String yieldValue = "";
    var amountInStakingContract = BigInt.from(Random().nextInt(200));
    while (true) {
      await Future.delayed(Duration(seconds: 2));
      try {
        EthereumAddress stakingAccount =
            await credentials.extractAddress();
        amountInStakingContract += BigInt.one;
        yieldValue = "$amountInStakingContract";
      } catch (e) {
        print("Something failed while attempting to view staked Amount /n $e");
        yieldValue = "-";
      }
      yield yieldValue;
    }
  }

  Stream<String> getAPY() async* {
    String yieldValue = "0";

    while (true) {
      // yieldValue = rewards;
      try {
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        print("[Console] Failed at getting APY: \n $e");
        yieldValue = "-";
      }
      yield yieldValue;
    }
  }

  Stream<BigInt> rewardsEarned() async* {
    try {
      await Future.delayed(Duration(seconds: 2));
      yield await _stakingRewards.rewardPerToken();
    } catch (e) {
      yield BigInt.from(Random().nextInt(200));
    }
  }

  Stream<BigInt> unclaimedRewards() async* {
    EthereumAddress account = await credentials.extractAddress();
    try {
      await Future.delayed(Duration(seconds: 2));
      yield await _stakingRewards.earned(account);
    } catch (e) {
      yield BigInt.zero;
    }
  }

  // Actionables
  Future<void> stakeAX(int amountToStake) async {
    Credentials stakeCredentials = this.credentials;
    BigInt stakeAmount = BigInt.from(amountToStake * (pow(10, 18)));
    Transaction _transaction = Transaction(
        maxGas: 5500000,
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10));

    try {
      _athleteX.approve(stakingAddr, stakeAmount,
          credentials: this.credentials);
      _stakingRewards.stake(stakeAmount,
          credentials: stakeCredentials, transaction: _transaction);
    } catch (e) {
      print("Failed at Staking: $e");
    }
  }

  Future<void> claimRewards() async {
    _stakingRewards.getReward(credentials: this.credentials);
  }

  Future<void> unstakeAX(int amountToUnstake) async {
    Credentials stakeCredentials = this.credentials;
    BigInt withdrawAmount = BigInt.from(amountToUnstake * (pow(10, 18)));
    Transaction _transaction = Transaction(
        maxGas: 5500000,
        gasPrice: EtherAmount.fromUnitAndValue(EtherUnit.gwei, 10));

    try {
      _athleteX.approve(stakingAddr, withdrawAmount,
          credentials: stakeCredentials);
      _stakingRewards.withdraw(withdrawAmount,
          credentials: stakeCredentials, transaction: _transaction);
    } catch (e) {
      print("Failed at Withdraw: \n $e");
    }
  }
}