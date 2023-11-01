import 'package:wallet_repository/wallet_repository.dart';

class OnrampOfframpRepository {
  OnrampOfframpRepository();

  String baseDataUrl = 'https://api.kado.money/?onPayAmount?';
  var publicAPIKey = '';
  var minimalParam = '&mode=minimal';

  Future<void> buyUSDC(EthereumChain chain) async {
    var params = '&product=BUY';
  }

  Future<void> sellUSDC() async {
    var params = '&product=SELL';
  }

  Future<void> buyCrypto() async {}

  Future<void> sellCrypto() async {}
}
