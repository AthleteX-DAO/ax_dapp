// ignore_for_file: unused_field

import 'package:ax_dapp/service/Controller/Controller.dart';
import 'package:ax_dapp/service/Controller/Swap/AXT.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/LongShortPair.g.dart';
import '../../contracts/ExpiringMultiParty.g.dart';

mixin APTBehavior on Token {
  Controller controller = Get.find();
  AXT _athleteX = AXT("AthleteX", "AX");
  final EthereumAddress placeholderAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");
  EthereumAddress empCAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");

  late ExpiringMultiParty _expiringMultiParty;

  // When we create options put/call behavior
  late LongShortPair _longShortPair;

  // late LongShortPair _longShortPair =
  //     LongShortPair(address: placeholderAddress, client: client);
  // Actionables

  Future<String> mint(double amtCollateral, double amtTokens) async {
    String txString;
    BigInt tokensToCreate = BigInt.from(amtCollateral);
    BigInt collateralAmount = BigInt.from(amtTokens);
    try {
      txString = await _expiringMultiParty.create(
          collateralAmount, tokensToCreate,
          credentials: controller.credentials);
    } catch (e) {
      txString = "Unable to create APT $e";
    }

    return txString;
  }

  Future<String> redeem(double numTokens) async {
    String txString;
    BigInt tokensToRedeem = BigInt.from(numTokens);
    try {
      txString = await _expiringMultiParty.redeem(tokensToRedeem,
          credentials: controller.credentials);
    } catch (e) {
      txString = "unable to redeem";
      print("You are not the token sponsor");
    }

    return txString;
  }
}
