// ignore_for_file: non_constant_identifier_names
import 'package:ax_dapp/service/controller/controller.dart';
import 'package:ax_dapp/util/user_input_norm.dart';
import 'package:erc20/erc20.dart';
import 'package:ethereum_api/lsp_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class LongShortPairRepository {
  LongShortPairRepository();
  Controller controller = Controller();
  late LongShortPair genericLSP;
  RxDouble createAmt = 0.0.obs;
  RxDouble redeemAmt = 0.0.obs;
  RxString aptAddress = ''.obs;
  Web3Client tokenClient = Web3Client('https://polygon-rpc.com', Client());

  String get tokenAddress => aptAddress.value;
  double get createAmount => createAmt.value;
  double get redeemAmount => redeemAmt.value;

  set tokenAddress(String pairAddress) => aptAddress.value = pairAddress;
  set createAmount(double newAmount) => createAmt.value = newAmount;
  set redeemAmount(double newAmount) => redeemAmt.value = newAmount;

  Future<void> mint() async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    final tokensToCreate = normalizeInput(createAmt.value);
    final txString =
        await genericLSP.create(tokensToCreate, credentials: theCredentials);
    controller.transactionHash = txString; //Sends tx to controller
  }

  Future<void> approve(String axtAddress) async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final transferAmount = await genericLSP.collateralPerPair();
    final amount = normalizeInput(createAmt.value) *
        transferAmount ~/
        BigInt.from(10).pow(18); // removes 18 zeros from collateralPerPair
    final axtEthereumAddress = EthereumAddress.fromHex(axtAddress);
    final axt = ERC20(address: axtEthereumAddress, client: tokenClient);
    await axt.approve(address, amount, credentials: controller.credentials);
  }

  Future<bool> redeem() async {
    final address = EthereumAddress.fromHex(aptAddress.value);
    genericLSP = LongShortPair(address: address, client: tokenClient);
    final theCredentials = controller.credentials;
    final tokensToRedeem = normalizeInput(redeemAmt.value);
    try {
      await genericLSP.redeem(tokensToRedeem, credentials: theCredentials);
      return true;
    } catch (_) {
      return false;
    }
  }
}
