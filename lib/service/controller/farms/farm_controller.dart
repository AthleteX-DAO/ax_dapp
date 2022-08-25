import 'dart:typed_data';

import 'package:ax_dapp/pages/farm/models/farm_model.dart';
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_info.dart';
import 'package:config_repository/config_repository.dart';
import 'package:ethereum_api/erc20_api.dart';
import 'package:ethereum_api/pool_api.dart';
import 'package:ethereum_api/pool_info_api.dart';
import 'package:get/get.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:use_cases/stream_app_data_changes_use_case.dart';
import 'package:wallet_repository/wallet_repository.dart';
import 'package:web3dart/web3dart.dart' as web3_dart;

class FarmController {
  // contructor with poolInfo from api
  FarmController({
    required FarmModel farm,
    required WalletRepository walletRepository,
    required TokensRepository tokensRepository,
    required ConfigRepository configRepository,
    required StreamAppDataChangesUseCase streamAppDataChanges,
  }) : _walletRepository = walletRepository {
    strAddress = farm.strAddress;
    strName = farm.strName;
    athlete =
        tokensRepository.currentApts.findAptNameByAlias(farm.strStakedAlias);
    sport =
        tokensRepository.currentApts.findAptSportByAlias(farm.strStakedAlias);
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

    final appConfig = configRepository.initializeAppConfig();
    rpcClient = appConfig.reactiveWeb3Client.value;
    contract = Pool(address: address, client: rpcClient);
    final chain = walletRepository.currentChain.isSupported
        ? walletRepository.currentChain
        : walletRepository.defaultChain;
    contractInfo = chain.createPoolInfo(rpcClient);

    final account = _walletRepository.currentWallet.address;
    updateStakedBalance(account);
    updateCurrentBalance();

    streamAppDataChanges.appDataChanges.listen((appData) {
      final chain = appData.chain;
      final appConfig = appData.appConfig;
      rpcClient = appConfig.reactiveWeb3Client.value;
      contract = Pool(address: address, client: rpcClient);
      contractInfo = chain.createPoolInfo(rpcClient);
      final account = _walletRepository.currentWallet.address;
      updateStakedBalance(account);
      updateCurrentBalance();
    });
  }

  // constructor from another farm
  FarmController.fromFarm({
    required FarmController farm,
    required WalletRepository walletRepository,
  }) : _walletRepository = walletRepository {
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
    contractInfo = farm.contractInfo;
    stakingInfo = farm.stakingInfo;
    stakedInfo = farm.stakedInfo;

    final account = _walletRepository.currentWallet.address;
    updateStakedBalance(account);
    updateCurrentBalance();
  }

  final WalletRepository _walletRepository;

  // decalaration of member varibles
  late Pool contract;
  late PoolInfo contractInfo;

  Controller controller = Get.find();
  String? athlete;
  String strName = '';
  SupportedSport sport = SupportedSport.all;
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
  Rx<UserInputInfo> rewardInfo = UserInputInfo(BigInt.zero, '0.0').obs;

  late web3_dart.Web3Client rpcClient;

  /// This function is used to get current Balance from wallet
  ///
  /// @return {void}
  Future<void> updateCurrentBalance() async {
    final rawBalance =
        await _walletRepository.getRawTokenBalance(strStakeTokenAddress);
    stakingInfo.value = UserInputInfo.fromBalance(
      rawAmount: rawBalance,
      decimals: nStakeTokenDecimals,
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
      rewardInfo.value.rawAmount,
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

    final rewards =
        await contractInfo.rewards(contract.self.address, ethAccount);
    rewardInfo.value = UserInputInfo.fromBalance(
      rawAmount: rewards[0],
      decimals: nRewardTokenDecimals,
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
