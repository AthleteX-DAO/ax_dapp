import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';
import 'package:ax_dapp/sports_markets/repository/repository.dart';

class GetSportsMarketsDataUseCase {
  GetSportsMarketsDataUseCase({
    required this.sxMarketsRepository,
    required this.overTimeMarketsRepository,
  });

  final SXMarketsRepository sxMarketsRepository;
  final OverTimeMarketsRepository overTimeMarketsRepository;

  Future<List<SportsMarketsModel>> fetchliveMarkets() async {
    final sportsMaketModel = <SportsMarketsModel>[];
    final sxMarkets = await sxMarketsRepository.fetchSXMarkets();
    final overTimeMarkets =
        await overTimeMarketsRepository.fetchOverTimeMarkets(chainId: 10);
    sportsMaketModel
      ..addAll(sxMarkets)
      ..addAll(overTimeMarkets);
    return sportsMaketModel;
  }
}
