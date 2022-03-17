import 'dart:convert';
import 'package:flutter/material.dart';
import 'Coin.dart';
import 'package:http/http.dart' as http;

class CoinApi {
  Future<List<Coin>> getCoins(BuildContext context) async {
    var allData = await http.get(Uri.parse(
        "https://rest.coinapi.io/v1/assets?apikey=8E8E1331-682E-4FAF-8E61-5D658F7B9AD4"));
    var allBody = json.decode(allData.body);

    // final assetBundle = DefaultAssetBundle.of(context);
    // final ourData = await assetBundle.loadString('assets/coins.json');
    // final ourBody = json.decode(ourData);

    var tickerList = ["ETH", "WBTC", "AX", "USDC", "DAI"];

    var allList = allBody.map<Coin>(Coin.fromJson).toList();
    List<Coin> ourList = [];

    for (Coin coin in allList) {
      if (tickerList.contains(coin.ticker)) ourList.add(coin);
    }

    return ourList;
  }
}
