import 'dart:convert';

import 'package:ax_dapp/service/coin.dart';
import 'package:http/http.dart' as http;

class CoinApi {
  Future<List<Coin>> getCoins() async {
    final data = await http.get(
      Uri.parse(
        'https://rest.coinapi.io/v1/assets?apikey=8E8E1331-682E-4FAF-8E61-5D658F7B9AD4',
      ),
    );
    final coinsJson = json.decode(data.body) as List<dynamic>;

    final tickerList = ['ETH', 'WBTC', 'AX', 'USDC', 'DAI'];

    final coins =
        List<Map<String, dynamic>>.from(coinsJson).map(Coin.fromJson).toList();
    return coins.where((coin) => tickerList.contains(coin.ticker)).toList();
  }
}
