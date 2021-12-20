import 'dart:convert';
import 'dart:typed_data';

import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/Controller.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/LongShortPair.g.dart';
import '../../contracts/ExpiringMultiParty.g.dart';
import 'package:ae_dapp/service/Controller/AXT.dart';
import '../../contracts/LongShortPairCreator.g.dart';
import '../../contracts/ExpiringMultiPartyCreator.g.dart';
import 'package:ae_dapp/service/Controller/SWAPBehavior.dart';

class APTBehavior {
  SWAPBehavior _swapBehavior = SWAPBehavior();
  AXT _athleteX = AXT("AthleteX", "AX");
  final EthereumAddress placeholderAddress =
      EthereumAddress.fromHex("0x00000000000000000000000000000000000000");
  EthereumAddress empCAddress =
      EthereumAddress.fromHex("0x00000000000000000000000000000000000000");


  late ExpiringMultiParty _expiringMultiParty;

  // When we create options put/call behavior
  late LongShortPair _longShortPair;

  APTBehavior(EthereumAddress aptAddress) {
    _expiringMultiParty =
        ExpiringMultiParty(address: aptAddress, client: Controller.client);
  }

  APTBehavior.empty();

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
          credentials: Controller.credentials);
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
          credentials: Controller.credentials);
    } catch (e) {
      txString = "unable to redeem";
      print("You are not the token sponsor");
    }

    return txString;
  }

  Future<String> buy(EthereumAddress aptAddress, double numTokens) async {
    String txString;
    try {
      txString =
          await _swapBehavior.swapFromAX(aptAddress, BigInt.from(numTokens));
      print("[console] bought $aptAddress at ");
    } catch (e) {
      txString = "Unable to buy $aptAddress";
      print("Unable to buy tokens \n $e");
    }

    return txString;
  }

  Future<String> sell(EthereumAddress aptAddress, double numTokens) async {
    String txString;
    try {
      txString =
          await _swapBehavior.swapforAX(aptAddress, BigInt.from(numTokens));
    } catch (e) {
      txString = "Unable to sell $aptAddress";
    }
    return txString;
  }
}
