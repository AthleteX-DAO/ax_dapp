import 'package:ax_dapp/markets/markets.dart';

import 'package:tokens_repository/tokens_repository.dart';

class GetSportsDataUseCase {
  GetSportsDataUseCase({
    required TokensRepository tokensRepository,
  });

  Future<SportsMarketsModel> fetchSportsMarkets() async {
    final allSportsMarkets = <SportsMarketsModel>[];
  }
}
