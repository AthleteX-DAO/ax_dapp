import 'dart:convert';

import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/markets/modules/sports_markets/models/overtime_market_models/overtime_market.dart';
import 'package:flutter/material.dart';
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
          'Content-Type, Authorization, X-Requested-With',
    };
    try {
      final response = await http.get(baseDataUrl, headers: headers);
      final data = jsonDecode(response.body);
      debugPrint(
        'Sports Markets Response: $response \n\n\n response Data: $data',
      );
      final sxBetMarkets = SXMarket.fromJson(data as Map<String, dynamic>);

      debugPrint('Sports Markets Data: $sxBetMarkets');

      for (final markets in sxBetMarkets.data.markets) {
        final id = markets.sportId;
        final name =
            '${markets.leagueLabel}| ${markets.outcomeOneName} & ${markets.outcomeTwoName}';
        const typeOfMarket = SupportedMarkets.Sports;
        final marketHash = markets.marketHash;
        final bookPrice = markets.mainLine;
        final marketLine = markets.line;
        final isMainLine = markets.mainLine;
        marketsLive.add(
          SportsMarketsModel(
            id: id,
            name: name,
            typeOfMarket: typeOfMarket,
            marketHash: marketHash,
            line: marketLine,
            mainLine: isMainLine,
          ),
        );
      }
      debugPrint('$marketsLive');
    } catch (e) {
      debugPrint('$e');
      return [];
    }

    return marketsLive;
  }

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
      debugPrint(
        'Sports Markets Response: $response \n\n\n response Data: $data',
      );
      final overtimeMarkets = data
          .map(
            (market) => OvertimeMarket.fromJson(market as Map<String, dynamic>),
          )
          .toList();
      debugPrint('Sports Markets Data: $overtimeMarkets');
      for (final market in overtimeMarkets) {
        final id = int.parse(market.gameId);
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
      debugPrint('$e');
      return [];
    }

    return marketsLive;
  }

  Future<void> fetchPolyMarketsSports() async {}
}
