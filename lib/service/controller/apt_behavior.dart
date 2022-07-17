// ignore_for_file: unused_field

import 'package:ax_dapp/contracts/ExpiringMultiParty.g.dart';
import 'package:ax_dapp/contracts/LongShortPair.g.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/controller/token.dart';
import 'package:web3dart/web3dart.dart';

mixin APTBehavior on Token {
  final AXT _athleteX = AXT('AthleteX', 'AX');
  final EthereumAddress placeholderAddress =
      EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');
  EthereumAddress empCAddress =
      EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

  late ExpiringMultiParty _expiringMultiParty;

  // When we create options put/call behavior
  late LongShortPair _longShortPair;

  // late LongShortPair _longShortPair =
  //     LongShortPair(address: placeholderAddress, client: client);
  // Actionables

  Future<String> mint(double amtCollateral, double amtTokens) async {
    String txString;
    final tokensToCreate = BigInt.from(amtCollateral);
    final collateralAmount = BigInt.from(amtTokens);
    try {
      txString = await _expiringMultiParty.create(
        collateralAmount,
        tokensToCreate,
        credentials: controller.credentials,
      );
    } catch (e) {
      txString = 'Unable to create APT $e';
    }

    return txString;
  }

  Future<String> redeem(double numTokens) async {
    String txString;
    final tokensToRedeem = BigInt.from(numTokens);
    try {
      txString = await _expiringMultiParty.redeem(
        tokensToRedeem,
        credentials: controller.credentials,
      );
    } catch (e) {
      // You are not the token sponsor
      txString = 'unable to redeem';
    }

    return txString;
  }
}
