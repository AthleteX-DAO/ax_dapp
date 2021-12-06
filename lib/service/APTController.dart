import 'package:ae_dapp/service/Controller.dart';
import 'package:web3dart/contracts/erc20.dart';
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

  Future<void> mint(
      EthereumAddress mintAddress, int collateralAmount, int numTokens) async {
    try {
      Erc20 mintingAPT = Erc20(address: mintAddress, client: client);
      _expiringMultiParty.create(collateralAmount, numTokens,
          credentials: credentials);
    } catch (e) {}
  }

  Future<void> redeem(int numTokens) async {
    try {
      _expiringMultiParty.redeem(numTokens, credentials: credentials);
    } catch (e) {
      print("You are not the token sponsor");
    }
  }
}
