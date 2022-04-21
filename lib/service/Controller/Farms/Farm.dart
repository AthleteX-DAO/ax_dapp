import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:ax_dapp/util/helper.dart';
import 'package:flutter_web3/ethers.dart';
import 'package:web3dart/credentials.dart';
import 'package:ax_dapp/contracts/Pool.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';

class Farm {
  late Pool _pool;
  late String farmAddressString;
  String? athlete;
  String name = "";
  String tvl = "";
  String swapFeeAPY = "";
  String axRewardsAPY = "";
  String totalAPY = "";
  String stakingAddress = "";
  String rewardAddress = "";
  double currentStaked = 0.0;
  Controller controller = Get.find();
  String tvlInUSD = "";

  // Formula for calculating TVL //
  // TVL = (TKNPriceInUSD * TKNAmount) + (TKNPriceInUSD * TKNAmount locked) ,

  // Farm(String name, String stakingAddress, String rewardAddress,
  //     [String? athelete]) {}
  //   this.name = name;
  //   this.stakingAddress = stakingAddress;
  //   this.rewardAddress = rewardAddress;
  //   this.athlete = athelete;
  // }

  Farm(
    String name,
    String stakingAddress,
  ) {
    this.name = name;
    String hex = stakingAddress;
    var farmAddress = EthereumAddress.fromHex(hex);
    this._pool = Pool(address: farmAddress, client: controller.client.value);
  }

  /// This function is used to stake tokens on a specific farm
  ///
  /// @param {BigInt} this is the amount of the staking
  /// @param {Farm} this is the information of the farm
  ///
  /// @return {String} the hash value of the transaction
  Future<String> stake(double stake) async {
    String stakingString = abiCoder.encode(['address'], [farmAddressString]);
    Uint8List stakingData = Uint8List.fromList(stakingString.codeUnits);

    // This is interesting + relevant
    String rewardString = abiCoder.encode(
        ['address', 'uint256', 'uint256', 'uint256'],
        [farmAddressString, 0.5, 0.5, days(90)]);
    Uint8List rewardData = Uint8List.fromList(rewardString.codeUnits);

    BigInt amount = BigInt.from(stake);
    String hash = await _pool.stake(amount, stakingData, rewardData,
        credentials: controller.credentials);
    return hash;
  }

  /// This function is used to unstake tokens on a specific farm
  ///
  /// @param {double} this is the decimal amount to unstake
  ///
  /// @return {String} the hash value of the transaction
  Future<String> unstake(double unstake) async {
    Uint8List rewardData =
        Uint8List.fromList(abiCoder.encode([], []).codeUnits);
    Uint8List stakingData =
        Uint8List.fromList(abiCoder.encode([], []).codeUnits);

    BigInt amount = BigInt.from(unstake);
    String hash = await _pool.unstake(amount, stakingData, rewardData,
        credentials: controller.credentials);
    return hash;
  }

  /// @title claim function
  ///
  /// @return {String}
  Future<String> claim() async {
    String stakingString = abiCoder.encode(['address'], [farmAddressString]);
    Uint8List stakingData = Uint8List.fromList(stakingString.codeUnits);

    String rewardString = abiCoder.encode(
        ['address', 'uint256', 'uint256', 'uint256'],
        [farmAddressString, 0.5, 0.5, 90]);
    Uint8List rewardData = Uint8List.fromList(rewardString.codeUnits);

    String hash = await _pool.claim(BigInt.from(100), stakingData, rewardData,
        credentials: controller.credentials);
    return hash;
  }

  void calculateTVL() async {
    var totalRewards = await _pool.rewardBalances();
    var totalStaked = await _pool.stakingTotals();
    tvlInUSD = totalRewards + totalStaked;
  }
}
