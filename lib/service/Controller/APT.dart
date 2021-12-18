import 'package:ae_dapp/service/Controller/Token.dart';
import 'package:web3dart/credentials.dart';

// Composition & Has-A relationship not Is-A relationship

class APT extends Token {
  late final EthereumAddress tokenContract; //EMP
  EthereumAddress? optionsContract; //LSP
  late final String name;

  var bookPrice, marketPrice;
  var address;
  var icon;

  var ticker;

  APT(this.name, this.ticker, this.icon)
      : super(super.name, super.ticker, super.icon);

  buy() {}
  sell() {}
  mint() {}
  redeem() {}
}
