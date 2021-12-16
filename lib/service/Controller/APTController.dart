import 'dart:convert';
import 'dart:typed_data';

import 'package:ae_dapp/service/Athlete.dart';
import 'package:ae_dapp/service/Controller/Controller.dart';
import 'package:ae_dapp/service/Controller/DEXController.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';
import '../../contracts/LongShortPairCreator.g.dart';
import '../../contracts/LongShortPair.g.dart';
import '../../contracts/ExpiringMultiPartyCreator.g.dart';
import '../../contracts/ExpiringMultiParty.g.dart';

class APTController extends Controller {
  late Credentials credentials;
  late Web3Client client;
  APTController() {
    client = super.client;
    credentials = super.credentials;
  }

  final EthereumAddress lspCAddress =
      EthereumAddress.fromHex("0x57EE47829369e2EF62fBb423648bec70d0366204");
  EthereumAddress empCAddress =
      EthereumAddress.fromHex("0xF0E8EFFDb48f09e91D2d9124a7D8c327CaD94f30");

  late LongShortPairCreator _longShortPairCreator =
      LongShortPairCreator(address: lspCAddress, client: client);
  late ExpiringMultiPartyCreator _expiringMultiPartyCreator =
      ExpiringMultiPartyCreator(address: empCAddress, client: client);

  late ExpiringMultiParty _expiringMultiParty =
      ExpiringMultiParty(address: lspCAddress, client: client);
  DEXController _DEX = DEXController();
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

    EthereumAddress collateralToken = axTokenAddr;

    EthereumAddress financialProductLibrary =
        EthereumAddress.fromHex("0xC7B7029373f504949553106c9eb2dAfDd48eF086");

    BigInt prepaidProposerReward = BigInt.zero;
    Uint8List customAncillaryData = Uint8List.fromList(utf8.encode('0'));

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
        credentials: credentials);
    return txString;
  }

  Future<void> redeem(int numTokens) async {
    try {
      _expiringMultiParty.redeem(numTokens, credentials: credentials);
    } catch (e) {
      print("You are not the token sponsor");
    }
  }

  Future<String> buy(EthereumAddress aptAddress, int numTokens) async {
    String txString;
    try {
      print("Attempting to buy APT");
      return _DEX.swapFromAX(aptAddress, BigInt.from(numTokens));
    } catch (e) {
      print("Unable to buy tokens \n $e");
      return _DEX.swapFromAX(aptAddress, BigInt.from(numTokens));
    }
  }

  Future<void> sell(EthereumAddress aptAddress, int numTokens) async {
    try {
      _DEX.swapforAX(aptAddress, BigInt.from(numTokens));
    } catch (e) {
      print('Unable to sell tokens \n $e');
    }
  }
}
