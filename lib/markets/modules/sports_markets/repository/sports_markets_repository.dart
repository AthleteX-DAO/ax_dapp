import 'dart:convert';

import 'package:ax_dapp/markets/markets.dart';
import 'package:ax_dapp/predict/models/prediction_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';
import 'package:tokens_repository/tokens_repository.dart';

class SportsMarketsRepository {
  Future<List<SportsMarketsModel>> fetchSXMarkets() async {
    final marketsLive = <SportsMarketsModel>[];
    final dio = Dio();
    const baseDataUrl = 'https://api.sx.bet/markets/active';
    final jsonString = (await dio.get<String>(baseDataUrl)).data!;
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final liveSXMarketsList = json['markets'] as Iterable<dynamic>;
    final marketsMap = liveSXMarketsList
        .map(
          (e) => {
            'id': e['sportId'] as String,
            'name': e['teamOneName'] as String,
            'recentPrice': e['line'] as String,
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

  Future<void> fetchOverTimeMarkets() async {}

  Future<void> fetchPolyMarketsSports() async {}
}
