import 'package:ax_dapp/athlete_markets/models/market_price_record.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/athlete_models/price_record.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:intl/intl.dart';
import 'package:tokens_repository/tokens_repository.dart';
import 'package:ax_dapp/markets/markets.dart';
import 'package:flutter/widgets.dart';

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
    int eventId,
  ) async {
    final eventPair = _tokensRepository.currentEventPair(eventId);
    final yesEventAddress = eventPair.yes.address;
    final noEventAddress = eventPair.no.address;
    final currentAxt = _tokensRepository.currentAxt;
    final formattedDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate));

    final yesRecords = _getMarketPriceRecords(
      yesEventAddress,
      currentAxt.address,
    );
    final noRecords = _getMarketPriceRecords(
      noEventAddress,
      currentAxt.address,
    );

    throw UnimplementedError('Implement getMarketPriceHistory');
  }

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

  Future<List<TokenPair>> fetchSpecificPairs(Token token, String startDate,
      {bool isLimited = true}) async {
    try {
      final response = await graphRepo.querySpecificPairs(
        token.ticker,
        startDate: startDate,
        isLimited: isLimited,
      );
      if (!response.isLeft()) return List.empty();
      final prefixInfos =
          response.getLeft().toNullable()!['prefix'] as List<dynamic>;
      final suffixInfos =
          response.getLeft().toNullable()!['suffix'] as List<dynamic>;
      final prefixPairs = List<Map<String, dynamic>>.from(prefixInfos)
          .map(TokenPair.fromJson)
          .toList();
      final suffixPairs = List<Map<String, dynamic>>.from(suffixInfos)
          .map(TokenPair.fromJson)
          .toList();
      final pairs = [...prefixPairs, ...suffixPairs];
      return pairs;
    } catch (e) {
      debugPrint('Error fetching specific pairs: $e');
      return List.empty();
    }
  }

  bool _equalsIgnoreCase(String? string1, String? string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }
}
