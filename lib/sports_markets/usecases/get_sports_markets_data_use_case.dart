import 'package:ax_dapp/sports_markets/models/sports_markets_model.dart';

class GetSportsMarketsDataUseCase {
  const GetSportsMarketsDataUseCase({this.sxMarketsRepository});

  final Object? sxMarketsRepository;

  Future<List<SportsMarketsModel>> fetchliveMarkets() async {
    return const [];
  }
}
