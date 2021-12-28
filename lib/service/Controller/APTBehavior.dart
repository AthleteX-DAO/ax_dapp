import 'dart:convert';
import 'dart:typed_data';

import 'package:ax_dapp/service/Athlete.dart';
import 'package:ax_dapp/service/Controller.dart';
import 'package:ax_dapp/service/Controller/AXT.dart';
import 'package:ax_dapp/service/Controller/SWAPBehavior.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/LongShortPairCreator.g.dart';
import '../../contracts/LongShortPair.g.dart';
import '../../contracts/ExpiringMultiPartyCreator.g.dart';
import '../../contracts/ExpiringMultiParty.g.dart';

class APTBehavior {
  SWAPBehavior _swapBehavior = SWAPBehavior();

  final EthereumAddress lspCAddress =
      EthereumAddress.fromHex("0x57EE47829369e2EF62fBb423648bec70d0366204");
  EthereumAddress empCAddress =
      EthereumAddress.fromHex("0xF0E8EFFDb48f09e91D2d9124a7D8c327CaD94f30");

  late LongShortPairCreator _longShortPairCreator =
      LongShortPairCreator(address: lspCAddress, client: Controller.client);
  late ExpiringMultiPartyCreator _expiringMultiPartyCreator =
      ExpiringMultiPartyCreator(
          address: empCAddress, client: Controller.client);

  late LongShortPair _longShortPair =
      LongShortPair(address: lspCAddress, client: Controller.client);

  late ExpiringMultiParty _expiringMultiParty =
      ExpiringMultiParty(address: lspCAddress, client: Controller.client);

  APTBehavior() {}

  // late LongShortPair _longShortPair =
  //     LongShortPair(address: lspCAddress, client: client);
  // Actionables

  Future<String> mint(int collateralAmount, int numTokens) async {
    
    String txString;
    Athlete athlete = Athlete(
        name: "Kevin Kamto",
        team: "ASU",
        position: "first",
        passingYards: [0, 1, 2],
        passingTouchDowns: [0, 2, 0, 2],
        reception: [],
        receiveTouch: [],
        receiveYards: [],
        war: [12],
        rushingYards: [11],
        time: [1]);

    BigInt collateralPerPair = BigInt.one;
    Uint8List priceIdentifier = Uint8List.fromList(utf8.encode('0x535044'));
    // Expiration is the end of the season - replace athlete.time with athlete.seasonEnd
    int expirationDate = DateTime.now().millisecondsSinceEpoch;
    BigInt expirationTimestamp = BigInt.from(expirationDate);

    String syntheticName = athlete.name;

    String syntheticSymbol = "ax{$athlete.name}";
    EthereumAddress collateralToken = AXT.mumbaiAddress;
    EthereumAddress financialProductLibrary =
        EthereumAddress.fromHex("0xC7B7029373f504949553106c9eb2dAfDd48eF086");
    Uint8List customAncillaryData = Uint8List.fromList(utf8.encode('0'));
    BigInt prepaidProposerReward = BigInt.zero;

    txString = await _longShortPairCreator.createLongShortPair(
        expirationTimestamp,
        collateralPerPair,
        priceIdentifier,
        syntheticName,
        syntheticSymbol,
        collateralToken,
        financialProductLibrary,
        customAncillaryData,
        prepaidProposerReward,
        credentials: Controller.credentials);
    return txString;
  }

  Future<String> redeem(int numTokens) async {
    String txString;
    BigInt theTokens = BigInt.from(numTokens);
    try {
      txString = await _longShortPair.redeem(theTokens,
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
