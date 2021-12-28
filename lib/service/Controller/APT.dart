import 'package:ax_dapp/service/Controller/APTBehavior.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/credentials.dart';

// Composition & Has-A relationship not Is-A relationship

class APT extends Token {
  late final EthereumAddress tokenContract; //EMP
  APTBehavior _aptBehavior = APTBehavior();
  EthereumAddress? optionsContract; //LSP
  late final String name;

  var bookPrice, marketPrice;


  APT(String name, String ticker) : super(name, ticker);

  buy(double buyAmount) {
    _aptBehavior.buy(address, buyAmount);
  }

  sell(double sellAmount) {
    _aptBehavior.sell(address, sellAmount);
  }

  mint(int collateral, int mintAmount) {
    _aptBehavior.mint(collateral, mintAmount);
  }

  redeem(int redeemAmount) {
    _aptBehavior.redeem(redeemAmount);
  }
}
