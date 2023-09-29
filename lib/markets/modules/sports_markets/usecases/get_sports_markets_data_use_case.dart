import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/widgets.dart';

class GetSportsMarketsDataUseCase {
  GetSportsMarketsDataUseCase({
    required this.sportsMarketsRepository,
  });

  SportsMarketsRepository sportsMarketsRepository;

  Future<List<SportsMarketsModel>> fetchliveMarkets() async {
    var allSportsMarkets = <SportsMarketsModel>[];

    final sx = await sportsMarketsRepository.fetchSXMarkets();

    for (final element in sx) {
      debugPrint('$element');
      allSportsMarkets.add(element);
    }
    return sx;
  }
}
