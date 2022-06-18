import 'dart:typed_data';
import 'package:ax_dapp/pages/farm/models/FarmModel.dart';
import 'package:ax_dapp/service/Controller/WalletController.dart';
import 'package:ax_dapp/util/UserInputInfo.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart' as Web3Dart;
import 'package:ax_dapp/contracts/Pool.g.dart';
import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/contracts/ERC20.g.dart';

class FarmController {
  // decalaration of member varibles
  late Pool contract;

  Controller controller = Get.find();
  WalletController wallet = Get.find();
  String? athlete;
  String strName = "";
  String strAddress = "";
  String strStakeTokenAddress = "";
  String strRewardTokenAddress = "";
  String strStakingModule = "";
  String strAPR = "";
  String strTVL = "";
  String strStakeTokenPrice = "";
  String strRewardTokenPrice = "";
  RxString strStaked = "".obs;
  RxString strRewards = "".obs;
  RxString strStakedSymbol = "".obs;
  RxString strRewardSymbol = "".obs;
  RxString strStakedAlias = "".obs;
  RxString strUnStakeInput = "".obs;
  RxString strStakeInput = "".obs;
  int nStakeTokenDecimals = 0;
  int nRewardTokenDecimals = 0;

  Rx<UserInputInfo> stakingInfo = UserInputInfo(BigInt.zero, "0.0").obs;
  Rx<UserInputInfo> stakedInfo = UserInputInfo(BigInt.zero, "0.0").obs;

  late Web3Dart.Web3Client rpcClient;

  // contructor with poolInfo from api
  FarmController(FarmModel farm) {
    this.strAddress = farm.strAddress;
    this.strName = farm.strName;
    this.strAPR = double.parse(farm.strAPR).toStringAsFixed(2);
    this.strTVL = double.parse(farm.strTVL).toStringAsFixed(2);
    this.strStaked = RxString(farm.strStaked);
    this.strRewards = RxString(farm.strRewards);
    this.strStakeTokenPrice = farm.strStakeTokenPrice;
    this.strRewardTokenPrice = farm.strRewardTokenPrice;
    this.strStakeTokenAddress = farm.strStakeTokenAddress;
    this.strRewardTokenAddress = farm.strRewardTokenAddress;
    this.strStakingModule = farm.strStakingModule;
    this.strStakedSymbol = RxString(farm.strStakedSymbol);
    this.strRewardSymbol = RxString(farm.strRewardSymbol);
    this.strStakedAlias = RxString(farm.strStakedAlias);
    this.nStakeTokenDecimals = farm.nStakeTokenDecimals;
    this.nRewardTokenDecimals = farm.nRewardTokenDecimals;

    Web3Dart.EthereumAddress address =
        Web3Dart.EthereumAddress.fromHex(this.strAddress);
    String rpcUrl = controller.mainRPCUrl;
    if (Controller.supportedChains.containsKey(controller.networkID.value))
      rpcUrl = Controller.supportedChains[controller.networkID.value]!;
    rpcClient = Web3Dart.Web3Client(rpcUrl, Client());
    this.contract = new Pool(address: address, client: rpcClient);
    this.updateCurrentBalance();
  }

  // constructor from another farm
  FarmController.fromFarm(FarmController farm) {
    this.strAddress = farm.strAddress;
    this.strName = farm.strName;
    this.strAPR = farm.strAPR;
    this.strTVL = farm.strTVL;
    this.strStaked = farm.strStaked;
    this.strRewards = farm.strRewards;
    this.strStakeTokenPrice = farm.strStakeTokenPrice;
    this.strRewardTokenPrice = farm.strRewardTokenPrice;
    this.strStakeTokenAddress = farm.strStakeTokenAddress;
    this.strRewardTokenAddress = farm.strRewardTokenAddress;
    this.strStakingModule = farm.strStakingModule;
    this.strStakedSymbol = farm.strStakedSymbol;
    this.strRewardSymbol = farm.strRewardSymbol;
    this.strStakedAlias = farm.strStakedAlias;
    this.nStakeTokenDecimals = farm.nStakeTokenDecimals;
    this.nRewardTokenDecimals = farm.nRewardTokenDecimals;
    this.rpcClient = farm.rpcClient;
    this.contract = farm.contract;
    this.stakingInfo = farm.stakingInfo;
    this.stakedInfo = farm.stakedInfo;

    String account = controller.publicAddress.value.hex;
    this.updateStakedBalance(account);
    this.updateCurrentBalance();
  }

  /// This function is used to get current Balance from wallet
  ///
  /// @return {void}
  Future<void> updateCurrentBalance() async {
    stakingInfo.value = await wallet.getTokenBalanceAsInfo(
        this.strStakeTokenAddress, this.nStakeTokenDecimals);
  }

  /// This function is used to stake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @return {void}
  Future<void> stake() async {
    Uint8List stakingData = Uint8List.fromList([]);
    Uint8List rewardData = Uint8List.fromList([]);
    UserInputInfo inputInfo = UserInputInfo.fromInput(
        inputAmount: this.strStakeInput.value,
        decimals: this.nStakeTokenDecimals);
    BigInt amount = getMaximumAmount(this.stakingInfo.value, inputInfo);
    String txHash = await this.contract.stake(amount, stakingData, rewardData,
        credentials: controller.credentials);
    controller.updateTxString(txHash);
  }

  /// This function is used to unstake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @param {double} this is the decimal amount to unstake
  ///
  /// @return {void}
  Future<void> unstake() async {
    Uint8List stakingData = Uint8List.fromList([]);
    Uint8List rewardData = Uint8List.fromList([]);
    UserInputInfo inputInfo = UserInputInfo.fromInput(
        inputAmount: this.strUnStakeInput.value,
        decimals: this.nStakeTokenDecimals);
    BigInt amount = getMaximumAmount(stakedInfo.value, inputInfo);
    String txHash = await this.contract.unstake(amount, stakingData, rewardData,
        credentials: controller.credentials);
    controller.updateTxString(txHash);
  }

  /// This function is used to stake tokens on a specific farm
  /// and also update the txHash string on conroller
  ///
  /// @return {void}
  Future<void> claim() async {
    Uint8List stakingData = Uint8List.fromList([]);
    Uint8List rewardData = Uint8List.fromList([]);

    String txHash = await this.contract.claim(
        BigInt.from(100), stakingData, rewardData,
        credentials: controller.credentials);
    controller.updateTxString(txHash);
  }

  /// This function is used to get balance of staked farm
  ///
  /// @param {String} the address of the account
  /// @return {void}
  Future<void> updateStakedBalance(String strAccount) async {
    Web3Dart.EthereumAddress ethAccount =
        Web3Dart.EthereumAddress.fromHex(strAccount);
    List<BigInt> balances = await this.contract.stakingBalances(ethAccount);
    this.stakedInfo.value = UserInputInfo.fromBalance(
        rawAmount: balances[0], decimals: this.nStakeTokenDecimals);
  }

  /// This function is used to approve the reward token
  ///
  /// @return {void}
  Future<void> approve() async {
    Web3Dart.EthereumAddress routerAddress =
        Web3Dart.EthereumAddress.fromHex(this.strStakingModule);
    Web3Dart.EthereumAddress tokenAddress =
        Web3Dart.EthereumAddress.fromHex(this.strStakeTokenAddress);
    ERC20 rewardToken = ERC20(address: tokenAddress, client: rpcClient);
    UserInputInfo inputInfo = UserInputInfo.fromInput(
        inputAmount: this.strStakeInput.value,
        decimals: this.nStakeTokenDecimals);
    BigInt amount = getMaximumAmount(this.stakingInfo.value, inputInfo);
    String txHash = await rewardToken.approve(routerAddress, amount,
        credentials: controller.credentials);
    controller.updateTxString(txHash);
  }

  BigInt getMaximumAmount(UserInputInfo raw, UserInputInfo input) {
    return input.rawAmount > raw.rawAmount ? raw.rawAmount : input.rawAmount;
  }
}
