import 'package:ae_dapp/service/Controller.dart';
import 'package:web3dart/web3dart.dart';
import '../contracts/LongShortPairCreator.g.dart';
import '../contracts/LongShortPair.g.dart';
import '../contracts/ExpiringMultiPartyCreator.g.dart';
import '../contracts/ExpiringMultiParty.g.dart';

class APTController extends Controller {
  final EthereumAddress lspCAddress =
      EthereumAddress.fromHex("0x8c086885624c5b823cc6fca7bff54c454d6b5239");
  late LongShortPair _longShortPair =
      LongShortPair(address: lspCAddress, client: client);
  late LongShortPairCreator _longShortPairCreator =
      LongShortPairCreator(address: lspCAddress, client: client);
  late ExpiringMultiPartyCreator _expiringMultiPartyCreator =
      ExpiringMultiPartyCreator(address: lspCAddress, client: client);
  late ExpiringMultiParty _expiringMultiParty =
      ExpiringMultiParty(address: lspCAddress, client: client);

  // Actionables
  Future<void> init() async {
    _longShortPairCreator.createLongShortPair(
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
  }

  Future<void> mintAPT() async {
    _expiringMultiPartyCreator.createExpiringMultiParty(params, credentials: credentials);
  }
}
