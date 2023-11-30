import 'dart:convert';

import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/models/sx_markets_models/sx_market.dart';
import 'package:http/http.dart' as http;

class SXMarketsRepository {
  Future<List<SportsMarketsModel>> fetchSXMarkets() async {
    final marketsLive = <SportsMarketsModel>[];
    final baseDataUrl = Uri.parse('https://api.sx.bet/markets/active');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'DELETE, POST, GET, OPTIONS',
      'Access-Control-Allow-Headers':
          'Content-Type, Authorization, X-Requested-With',
    };
    try {
      final response = await http.get(baseDataUrl, headers: headers);
      final data = jsonDecode(response.body);
      final sxBetMarkets = SXMarket.fromJson(data as Map<String, dynamic>);
      for (final markets in sxBetMarkets.data.markets) {
        final id = markets.sportId;
        final name =
            '${markets.leagueLabel}| ${markets.outcomeOneName} & ${markets.outcomeTwoName}';
        const typeOfMarket = SupportedMarkets.Sports;
        final marketHash = markets.marketHash;
        final marketLine = markets.line;
        final isMainLine = markets.mainLine;
        marketsLive.add(
          SportsMarketsModel(
            id: id.toString(),
            name: name,
            typeOfMarket: typeOfMarket,
            marketHash: marketHash,
            line: marketLine,
            mainLine: isMainLine,
          ),
        );
      }
    } catch (e) {
      return [];
    }

    return marketsLive;
  }
}
