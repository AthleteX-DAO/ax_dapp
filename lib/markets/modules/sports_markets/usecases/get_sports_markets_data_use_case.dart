import 'package:ax_dapp/markets/markets.dart';

class GetSportsMarketsDataUseCase {
  GetSportsMarketsDataUseCase({
    required this.sportsMarketsRepository,
  });

  SportsMarketsRepository sportsMarketsRepository;

  Future<List<SportsMarketsModel>> fetchliveMarkets() async {
    final allSportsMarkets = <SportsMarketsModel>[];
    final sxMarkets = await sportsMarketsRepository.fetchSXMarkets();

    for (final market in sxMarkets) {
      allSportsMarkets.add(market);
    }
    return sxMarkets;
  }
}
