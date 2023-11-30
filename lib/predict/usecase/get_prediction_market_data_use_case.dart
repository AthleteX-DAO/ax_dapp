import 'package:ax_dapp/athlete_markets/models/market_price_record.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:ax_dapp/markets/markets.dart';

class GetPredictionMarketDataUseCase {
  GetPredictionMarketDataUseCase({
    required TokensRepository tokensRepository,
    required this.graphRepo,
  }) : _tokensRepository = tokensRepository;

  final TokensRepository _tokensRepository;
  final SubGraphRepo graphRepo;

  List<TokenPair> allPairs = [];

  Future<MarketPriceRecord> getMarketPriceHistory(
    String startDate,
  ) async {}

  List<PriceRecord>? _getMarketPriceRecords(
    String strTokenAddr,
    String strAXTAddr,
  ) {
    // Looking for a pair which has the same token name as strTokenAddr
    // (token address as uppercase)
    final index0 = allPairs.indexWhere(
      (pair) =>
          _equalsIgnoreCase(pair.token0.id, strTokenAddr) &&
          _equalsIgnoreCase(pair.token1.id, strAXTAddr),
    );
    final index1 = allPairs.indexWhere(
      (pair) =>
          _equalsIgnoreCase(pair.token0.id, strAXTAddr) &&
          _equalsIgnoreCase(pair.token1.id, strTokenAddr),
    );

    return allPairs[index0 >= 0 ? index0 : index1]
        .pairHourData
        ?.asMap()
        .entries
        .map((entry) {
      final price = index0 >= 0
          ? double.parse(entry.value.reserve1) /
              double.parse(entry.value.reserve0)
          : double.parse(entry.value.reserve0) /
              double.parse(entry.value.reserve1);

      final date =
          DateTime.fromMillisecondsSinceEpoch(entry.value.hourStartUnix * 1000);

      return PriceRecord(
        price: price,
        timestamp: date.toString(),
      );
    }).toList();
  }

  bool _equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
