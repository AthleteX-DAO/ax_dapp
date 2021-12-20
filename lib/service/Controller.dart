import 'dart:html';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/browser.dart';
import 'package:bip39/bip39.dart'
    as bip39; // Basics of BIP39 https://coldbit.com/bip-39-basics-from-randomness-to-mnemonic-words/

class Controller {
  static var client;
  static var credentials;
  static var publicAddress;
  Controller._privateConstructor();

  static final Controller _instance = Controller._privateConstructor();

  /// VARIABLES
  var rng = new Random().nextInt(999);
  var mnemonic;
  var privateAddress;
  bool activeChain = false;
  static const MAINNET_CHAIN_ID = 137;
  String mainRPCUrl = "https://polygon-rpc.com";
  String testRPCUrl = "https://matic-mumbai.chainstacklabs.com/";

  set axTokenAddress(EthereumAddress tokenAddress) {
    axTokenAddress = EthereumAddress.fromHex("${tokenAddress.hex}");
  }

  factory Controller() {
    return _instance;
  }

  void createNewMnemonic() {
    mnemonic = bip39.generateMnemonic();
  }

  Future<String> retrieveWallet([String? _mnemonic]) async {
    mnemonic = _mnemonic;
    privateAddress = bip39.mnemonicToSeedHex(mnemonic);
    credentials = EthPrivateKey.fromHex(privateAddress);
    return mnemonic;
  }

  // Web functionality
  void connect() async {
    final eth = window.ethereum;
    var newClient = Web3Client.custom(eth!.asRpcService());
    final credentials = await eth.requestAccount();
    print("[Console] connecting to the decentralized web!");
    update(newClient, credentials);
  }

  void update(Web3Client cl, Credentials cr) async {
    client = cl;
    credentials = cr;
    publicAddress = await cr.extractAddress();
    print("[Console] updated client: ${cl} and credentials: ${cr}");
  }

  void viewTx(String txAddress) async {
    String urlString = 'https://polygonscan.com/tx/$txAddress';
    await launch(urlString);
  }

  // Viewables
  Stream<BigInt> availableBalance() async* {
    EthereumAddress account = await this._credentials.extractAddress();
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
            await this._credentials.extractAddress();
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
    EthereumAddress account = await this._credentials.extractAddress();
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
      _athleteX.approve(stakingAddr, stakeAmount, credentials: this.credentials);
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
