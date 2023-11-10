import 'dart:convert';

import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/sports_markets/models/overtime_market_models/overtime_market.dart';
import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:http/http.dart' as http;
import 'package:tokens_repository/tokens_repository.dart';

class OverTimeMarketsRepository {
  Future<List<SportsMarketsModel>> fetchOverTimeMarkets({
    required int chainId,
  }) async {
    const baseUrl = 'https://api.thalesmarket.io';
    final url =
        Uri.parse('$baseUrl/overtime/networks/$chainId/markets?ungroup=true');
    final marketsLive = <SportsMarketsModel>[];
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body) as List<dynamic>;
      final overtimeMarkets = data
          .map(
            (market) => OvertimeMarket.fromJson(market as Map<String, dynamic>),
          )
          .toList();
      for (final market in overtimeMarkets) {
        final id = market.gameId;
        final name = '${market.homeTeam} ${market.awayTeam}';
        const typeOfMarket = SupportedMarkets.Sports;
        final marketHash = market.address;
        const marketLine = 0.0;
        marketsLive.add(
          SportsMarketsModel(
            id: id,
            name: name,
            typeOfMarket: typeOfMarket,
            marketHash: marketHash,
            line: marketLine,
            mainLine: false,
          ),
        );
      }
    } catch (e) {
      return [];
    }

    return marketsLive;
  }
}
