// File for getting the price of any APT  from the DEX

import 'package:ax_dapp/service/Athlete.dart';

class Prices {
  late Athlete athlete;

  var databaseUrl;
  var firstPrice, lastPrice;

  void getBookPrice() {
    //
  }

  void getMarketPrice() {}

  void query(String name) {
    String query =
        "SELECT $name, first(price) as StartingPrice, last(price) as LatestPrice from nfl;";
  }

  void getLatestAXPrice() {
    String query = "";
  }
}
