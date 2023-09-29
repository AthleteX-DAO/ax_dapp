import 'dart:convert';

import 'package:ax_dapp/markets/markets.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportsMarketsRepository {
  Future<List<SportsMarketsModel>> fetchSXMarkets() async {
    final marketsLive = <SportsMarketsModel>[];
    final baseDataUrl = Uri.parse('https://api.sx.bet/markets/active');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'DELETE, POST, GET, OPTIONS',
      'Access-Control-Allow-Headers':
          'Content-Type, Authorization, X-Requested-With'
    };
    final response = await http.get(baseDataUrl, headers: headers);
    final json = jsonDecode(response.body);
    final marketsData = json['data']['markets'];
    final liveSXMarketsList =
        List<Map<dynamic, dynamic>>.from(marketsData as Iterable<dynamic>);

    final marketsMap = liveSXMarketsList
        .map(
          (e) => {
            'id': e['sportId'] as String,
            'name': e['teamOneName'] as String,
            'recentPrice': e['line'] as int,
          },
        )
        .toList();
    for (final markets in marketsMap) {
      final id = markets['id'] as int;
      final name = markets['name'] as String;
      const typeOfMarket = SupportedMarkets.Sports;
      const marketPrice = 0.0;
      const bookPrice = 0.0;
      final recentPrice = markets['recentPrice'] as double;
      marketsLive.add(
        SportsMarketsModel(
          id: id,
          name: name,
          typeOfMarket: typeOfMarket,
          marketPrice: marketPrice,
          recentPrice: recentPrice,
          bookPrice: bookPrice,
        ),
      );
    }
    return marketsLive;
  }

  Future<void> fetchOverTimeMarkets() async {
    const API_URL = 'https://api.thalesmarket.io'; // base API URL
    const NETWORK_ID = 10; // optimism network ID
    const NETWORK = 'optimism'; // optimism network
    const SPORTS_AMM_CONTRACT_ADDRESS =
        '0x170a5714112daEfF20E798B6e92e25B86Ea603C1'; // SportsAMM contract address on optimism
    const MARKET_ADDRESS = '0xb157e64720d3ff251023119a5f6557067763b08a';

    const POSITION = 0; // select Chelsea position
    const BUY_IN = 100; // 100 sUSD
    const SLIPPAGE = 0.02; // slippage 2%
    final overTimeMarkets = <SportsMarketsModel>[];
    final dio = Dio();
    const baseUrl =
        '$API_URL/overtime/networks/$NETWORK_ID/markets/$MARKET_ADDRESS/quote?position=$POSITION&buyIn=$BUY_IN';
  }

  Future<void> fetchPolyMarketsSports() async {}
}
