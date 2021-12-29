import 'package:ax_dapp/service/Controller/APTBehavior.dart';
import 'package:ax_dapp/service/Controller/Token.dart';
import 'package:web3dart/credentials.dart';

// Composition & Has-A relationship not Is-A relationship

class APT extends Token {
  late final EthereumAddress tokenContract; //EMP
  late APTBehavior _aptBehavior;
  EthereumAddress? optionsContract; //LSP
  late final String name;

  var bookPrice, marketPrice;

  APT(String name, String ticker, [EthereumAddress? aptAddress]) : super(name, ticker) {
    if (aptAddress != null)
    {
    _aptBehavior = APTBehavior(aptAddress);
    }

    
  }

  buy(double buyAmount) {
    _aptBehavior.buy(address, buyAmount);
  }

  sell(double sellAmount) {
    _aptBehavior.sell(address, sellAmount);
  }

  mint(double collateral, double mintAmount) {
    _aptBehavior.mint(collateral, mintAmount);
  }

  redeem(double redeemAmount) {
    _aptBehavior.redeem(redeemAmount);
  }
}
