import 'dart:typed_data';

import 'package:ax_dapp/contracts/ERC20.g.dart';
import 'package:ax_dapp/contracts/Pool.g.dart';
import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/service/controller/wallet_controller.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/user_input_info.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3_dart;

class FarmController {
  // contructor with poolInfo from api
  FarmController(FarmModel farm) {
    strAddress = farm.strAddress;
    strName = farm.strName;
    athlete = _getAthleteTokenNameFromAlias(farm.strStakedAlias);
    strAPR = double.parse(farm.strAPR).toStringAsFixed(2);
    strTVL = double.parse(farm.strTVL).toStringAsFixed(2);
    strStaked = RxString(farm.strStaked);
    strRewards = RxString(farm.strRewards);
    strStakeTokenPrice = farm.strStakeTokenPrice;
    strRewardTokenPrice = farm.strRewardTokenPrice;
    strStakeTokenAddress = farm.strStakeTokenAddress;
    strRewardTokenAddress = farm.strRewardTokenAddress;
    strStakingModule = farm.strStakingModule;
    strStakedSymbol = RxString(farm.strStakedSymbol);
    strRewardSymbol = RxString(farm.strRewardSymbol);
    strStakedAlias = RxString(farm.strStakedAlias);
    nStakeTokenDecimals = farm.nStakeTokenDecimals;
    nRewardTokenDecimals = farm.nRewardTokenDecimals;

    final address = web3_dart.EthereumAddress.fromHex(strAddress);
    var rpcUrl = controller.mainRPCUrl;
    if (Controller.supportedChains.containsKey(controller.networkID.value)) {
      rpcUrl = Controller.supportedChains[controller.networkID.value]!;
    }
    rpcClient = web3_dart.Web3Client(rpcUrl, Client());
    contract = Pool(address: address, client: rpcClient);
    updateCurrentBalance();
  }

  // constructor from another farm
  FarmController.fromFarm(FarmController farm) {
    strAddress = farm.strAddress;
    strName = farm.strName;
    athlete = farm.athlete;
    strAPR = farm.strAPR;
    strTVL = farm.strTVL;
    strStaked = farm.strStaked;
    strRewards = farm.strRewards;
    strStakeTokenPrice = farm.strStakeTokenPrice;
    strRewardTokenPrice = farm.strRewardTokenPrice;
    strStakeTokenAddress = farm.strStakeTokenAddress;
    strRewardTokenAddress = farm.strRewardTokenAddress;
    strStakingModule = farm.strStakingModule;
    strStakedSymbol = farm.strStakedSymbol;
    strRewardSymbol = farm.strRewardSymbol;
    strStakedAlias = farm.strStakedAlias;
    nStakeTokenDecimals = farm.nStakeTokenDecimals;
    nRewardTokenDecimals = farm.nRewardTokenDecimals;
    rpcClient = farm.rpcClient;
    contract = farm.contract;
    stakingInfo = farm.stakingInfo;
    stakedInfo = farm.stakedInfo;

    final account = controller.publicAddress.value.hex;
    updateStakedBalance(account);
    updateCurrentBalance();
  }

  String? _getAthleteTokenNameFromAlias(String stakingAlias) {
    // returns athlete token name, returns null if stakingAlias is empty
    // stakingToken alias example: 'AJLT1010-AX' or 'AX-CCST1010' or ''
    if (stakingAlias.isEmpty) return null;
    final tickers = stakingAlias.split('-');
    //we want athlete ticker not 'AX'
    final athleteTicker = tickers[0] == 'AX' ? tickers[1] : tickers[0];
    return TokenList.mapTickerToName(athleteTicker);
  }

  // decalaration of member varibles
  late Pool contract;

  Controller controller = Get.find();
  WalletController wallet = Get.find();
  String? athlete;
  String strName = '';
  String strAddress = '';
  String strStakeTokenAddress = '';
  String strRewardTokenAddress = '';
  String strStakingModule = '';
  String strAPR = '';
  String strTVL = '';
  String strStakeTokenPrice = '';
  String strRewardTokenPrice = '';
  RxString strStaked = ''.obs;
  RxString strRewards = ''.obs;
  RxString strStakedSymbol = ''.obs;
  RxString strRewardSymbol = ''.obs;
  RxString strStakedAlias = ''.obs;
  RxString strUnStakeInput = ''.obs;
  RxString strStakeInput = ''.obs;
  int nStakeTokenDecimals = 0;
  int nRewardTokenDecimals = 0;

  Rx<UserInputInfo> stakingInfo = UserInputInfo(BigInt.zero, '0.0').obs;
  Rx<UserInputInfo> stakedInfo = UserInputInfo(BigInt.zero, '0.0').obs;

  late web3_dart.Web3Client rpcClient;

  /// This function is used to get current Balance from wallet
  ///
  /// @return {void}
  Future<void> updateCurrentBalance() async {
    stakingInfo.value = await wallet.getTokenBalanceAsInfo(
      strStakeTokenAddress,
      nStakeTokenDecimals,
    );
  }

  /// This function is used to stake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @return {void}
  Future<void> stake() async {
    final stakingData = Uint8List.fromList([]);
    final rewardData = Uint8List.fromList([]);
    final inputInfo = UserInputInfo.fromInput(
      inputAmount: strStakeInput.value,
      decimals: nStakeTokenDecimals,
    );
    final amount = getMaximumAmount(stakingInfo.value, inputInfo);
    final txHash = await contract.stake(
      amount,
      stakingData,
      rewardData,
      credentials: controller.credentials,
    );
    controller.updateTxString(txHash);
  }

  /// This function is used to unstake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @param {double} this is the decimal amount to unstake
  ///
  /// @return {void}
  Future<void> unstake() async {
    final stakingData = Uint8List.fromList([]);
    final rewardData = Uint8List.fromList([]);
    final inputInfo = UserInputInfo.fromInput(
      inputAmount: strUnStakeInput.value,
      decimals: nStakeTokenDecimals,
    );
    final amount = getMaximumAmount(stakedInfo.value, inputInfo);
    final txHash = await contract.unstake(
      amount,
      stakingData,
      rewardData,
      credentials: controller.credentials,
    );
    controller.updateTxString(txHash);
  }

  /// This function is used to stake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @return {void}
  Future<void> claim() async {
    final stakingData = Uint8List.fromList([]);
    final rewardData = Uint8List.fromList([]);

    final txHash = await contract.claim(
      BigInt.from(100),
      stakingData,
      rewardData,
      credentials: controller.credentials,
    );
    controller.updateTxString(txHash);
  }

  /// This function is used to get balance of staked farm
  ///
  /// @param {String} the address of the account
  /// @return {void}
  Future<void> updateStakedBalance(String strAccount) async {
    final ethAccount = web3_dart.EthereumAddress.fromHex(strAccount);
    final balances = await contract.stakingBalances(ethAccount);
    stakedInfo.value = UserInputInfo.fromBalance(
      rawAmount: balances[0],
      decimals: nStakeTokenDecimals,
    );
  }

  /// This function is used to approve the reward token
  ///
  /// @return {void}
  Future<void> approve() async {
    final routerAddress = web3_dart.EthereumAddress.fromHex(strStakingModule);
    final tokenAddress =
        web3_dart.EthereumAddress.fromHex(strStakeTokenAddress);
    final rewardToken = ERC20(address: tokenAddress, client: rpcClient);
    final inputInfo = UserInputInfo.fromInput(
      inputAmount: strStakeInput.value,
      decimals: nStakeTokenDecimals,
    );
    final amount = getMaximumAmount(stakingInfo.value, inputInfo);
    final txHash = await rewardToken.approve(
      routerAddress,
      amount,
      credentials: controller.credentials,
    );
    controller.updateTxString(txHash);
  }

  BigInt getMaximumAmount(UserInputInfo raw, UserInputInfo input) {
    return input.rawAmount > raw.rawAmount ? raw.rawAmount : input.rawAmount;
  }
}
