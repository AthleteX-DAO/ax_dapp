import 'package:ax_dapp/service/Controller/APTBehavior.dart';
import 'package:ax_dapp/service/Controller/ERC20Behavior.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/credentials.dart';

// Composition & Has-A relationship not Is-A relationship

class APT extends Token with APTBehavior, ERC20Behavior {
  late final EthereumAddress tokenContract; //EMP
  EthereumAddress? optionsContract; //LSP
  late final String name;

  var bookPrice, marketPrice;

  APT(String name, String ticker, [String? aptAddress]) : super(name, ticker) {
    updateAddress(aptAddress!);
  }
}
