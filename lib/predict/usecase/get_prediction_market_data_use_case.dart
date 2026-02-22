import 'dart:math';

import 'package:ax_dapp/predict/models/token_market_model.dart';
import 'package:ax_dapp/predict/predict.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:ax_dapp/service/prediction_models/prediction_models.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tokens_repository/tokens_repository.dart';

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
    allPairs =
        await fetchSpecificPairs(currentAxt, formattedDate, isLimited: false);

    final yesRecords = _getMarketPriceRecords(
      yesEventAddress,
      currentAxt.address,
    );
    final noRecords = _getMarketPriceRecords(
      noEventAddress,
      currentAxt.address,
    );

    return MarketPriceRecord(
      yesRecord: PredictionPriceRecord(
        id: 0,
        name: '',
        priceHistory: yesRecords!,
      ),
      noRecord: PredictionPriceRecord(
        id: 0,
        name: '',
        priceHistory: noRecords!,
      ),
    );
  }

  Future<MarketPriceRecord> getMockMarketPriceHistory(
    String startDate,
    int eventId,
  ) async {
    final random = Random(eventId.hashCode);
    final start = DateTime.parse(startDate);

    final yesStart = 0.25 + random.nextDouble() * 0.5;
    final noStart = 1 - yesStart;

    final yesHistory = _generateMockSeries(random, start, yesStart);
    final noHistory = _generateMockSeries(random, start, noStart, invert: true);

    return MarketPriceRecord(
      yesRecord: PredictionPriceRecord(
        id: eventId,
        name: 'YES',
        priceHistory: yesHistory,
      ),
      noRecord: PredictionPriceRecord(
        id: eventId,
        name: 'NO',
        priceHistory: noHistory,
      ),
    );
  }

  Future<List<PredictionModel>> fetchSupportedPredictionMarkets(
    SupportedPredictionMarkets supportedPredictionMarkets,
  ) async {
    final markets = _buildMockPredictionMarkets();
    if (supportedPredictionMarkets == SupportedPredictionMarkets.all) {
      return markets;
    }

    return markets
        .where(
          (market) =>
              market.supportedPredictionMarkets == supportedPredictionMarkets,
        )
        .toList();
  }

  List<PredictionModel> _buildMockPredictionMarkets() {
    final mockMarkets = <_MockPredictionMarket>[
      const _MockPredictionMarket(
        id: 1,
        prompt: 'who will win superbowl 2026',
        details: 'Projected championship odds for the 2026 Super Bowl field.',
        category: SupportedPredictionMarkets.football,
        endDate: '2026-02-08',
      ),
      const _MockPredictionMarket(
        id: 2,
        prompt: 'who will win the fifa world cup',
        details: 'Outright winner market for the 2026 FIFA World Cup.',
        category: SupportedPredictionMarkets.soccer,
        endDate: '2026-07-19',
      ),
      const _MockPredictionMarket(
        id: 3,
        prompt: 'who will win the Winter Olympics',
        details: 'Overall medal table leader for the 2026 Winter Games.',
        category: SupportedPredictionMarkets.exotic,
        endDate: '2026-02-22',
      ),
      const _MockPredictionMarket(
        id: 4,
        prompt: 'NFL Playoffs Bracket Set',
        details: 'Market on the final AFC/NFC playoff bracket seeding.',
        category: SupportedPredictionMarkets.football,
        endDate: '2026-01-05',
      ),
      const _MockPredictionMarket(
        id: 5,
        prompt: '2026 NBA Finals MVP',
        details: 'MVP honors for the 2026 NBA Finals series.',
        category: SupportedPredictionMarkets.basketball,
        endDate: '2026-06-25',
      ),
      const _MockPredictionMarket(
        id: 6,
        prompt: '2026 NBA Finals Champion',
        details: 'Outright winner for the 2026 NBA title.',
        category: SupportedPredictionMarkets.basketball,
        endDate: '2026-06-20',
      ),
      const _MockPredictionMarket(
        id: 7,
        prompt: '2026 World Series Winner',
        details: "Which club lifts the Commissioner's Trophy in 2026.",
        category: SupportedPredictionMarkets.baseball,
        endDate: '2026-11-05',
      ),
      const _MockPredictionMarket(
        id: 8,
        prompt: '2026 Stanley Cup Champion',
        details: 'NHL postseason futures for the 2026 Stanley Cup.',
        category: SupportedPredictionMarkets.hockey,
        endDate: '2026-06-15',
      ),
      const _MockPredictionMarket(
        id: 9,
        prompt: '2026 March Madness Champion',
        details: 'Who cuts down the nets at the 2026 NCAA tournament.',
        category: SupportedPredictionMarkets.college,
        endDate: '2026-04-06',
      ),
      const _MockPredictionMarket(
        id: 10,
        prompt: '2026 College Football Champion',
        details: 'CFP title odds for the 2026 season.',
        category: SupportedPredictionMarkets.college,
        endDate: '2026-01-12',
      ),
      const _MockPredictionMarket(
        id: 11,
        prompt: '2026 UEFA Champions League Winner',
        details: 'Outright UCL winner for the 2025/26 campaign.',
        category: SupportedPredictionMarkets.soccer,
        endDate: '2026-05-31',
      ),
      const _MockPredictionMarket(
        id: 12,
        prompt: '2026 Copa America Winner',
        details: 'Champion of the expanded 2026 Copa America field.',
        category: SupportedPredictionMarkets.soccer,
        endDate: '2026-07-12',
      ),
      const _MockPredictionMarket(
        id: 13,
        prompt: '2026 Formula 1 Constructors Champion',
        details: 'Team standings futures for the 2026 F1 season.',
        category: SupportedPredictionMarkets.exotic,
        endDate: '2026-12-01',
      ),
      const _MockPredictionMarket(
        id: 14,
        prompt: "2026 Wimbledon Women's Champion",
        details: "Ladies' singles outright at Wimbledon 2026.",
        category: SupportedPredictionMarkets.exotic,
        endDate: '2026-07-11',
      ),
      const _MockPredictionMarket(
        id: 15,
        prompt: "2026 US Open Men's Champion",
        details: 'Mens singles outright at Flushing Meadows 2026.',
        category: SupportedPredictionMarkets.exotic,
        endDate: '2026-09-13',
      ),
      const _MockPredictionMarket(
        id: 16,
        prompt: 'Community pick: shorten shot clock to 22s?',
        details: 'Community governance vote on pro basketball shot clocks.',
        category: SupportedPredictionMarkets.voted,
        endDate: '2026-03-15',
      ),
      const _MockPredictionMarket(
        id: 17,
        prompt: '2026 NBA Draft #1 Pick',
        details: 'Who goes first overall in the 2026 NBA Draft.',
        category: SupportedPredictionMarkets.basketball,
        endDate: '2026-06-10',
      ),
      const _MockPredictionMarket(
        id: 18,
        prompt: '2026 AL MVP Winner',
        details: 'American League MVP honors for the 2026 season.',
        category: SupportedPredictionMarkets.baseball,
        endDate: '2026-11-20',
      ),
      const _MockPredictionMarket(
        id: 19,
        prompt: '2026 NHL Hart Trophy Winner',
        details: 'League MVP futures for the 2025/26 NHL season.',
        category: SupportedPredictionMarkets.hockey,
        endDate: '2026-06-22',
      ),
      const _MockPredictionMarket(
        id: 20,
        prompt: '2026 NFL Offensive Rookie of the Year',
        details: 'OROY race for the incoming 2026 rookie class.',
        category: SupportedPredictionMarkets.football,
        endDate: '2027-02-10',
      ),
      const _MockPredictionMarket(
        id: 21,
        prompt: 'Will the Lakers win 50+ games?',
        details: 'Regular season win total market for Los Angeles.',
        category: SupportedPredictionMarkets.basketball,
        endDate: '2026-04-15',
      ),
      const _MockPredictionMarket(
        id: 22,
        prompt: 'Will the Yankees make the postseason?',
        details: 'New York Yankees playoff berth odds for 2026.',
        category: SupportedPredictionMarkets.baseball,
        endDate: '2026-10-02',
      ),
      const _MockPredictionMarket(
        id: 23,
        prompt: 'Will Messi score 20+ MLS goals in 2026?',
        details: "Goal-scoring prop for Lionel Messi's 2026 MLS season.",
        category: SupportedPredictionMarkets.soccer,
        endDate: '2026-10-20',
      ),
      const _MockPredictionMarket(
        id: 24,
        prompt: 'Will Colorado reach 8+ wins?',
        details: 'Regular season win total for Colorado football.',
        category: SupportedPredictionMarkets.college,
        endDate: '2026-12-05',
      ),
    ];

    return mockMarkets.map(_createMockPredictionModel).toList();
  }

  PredictionModel _createMockPredictionModel(_MockPredictionMarket mock) {
    final seededRandom = Random(mock.prompt.hashCode);
    final yesPrice = 0.25 + seededRandom.nextDouble() * 0.5;
    final noPrice = 1 - yesPrice;
    final tradingVolume = 500000 + seededRandom.nextDouble() * 4500000;

    final marketAddress =
        '0x${mock.id.toRadixString(16).padLeft(40, '0').toUpperCase()}';
    final yesTokenAddress =
        '0x${(mock.id * 2 + 1).toRadixString(16).padLeft(40, '0').toUpperCase()}';
    final noTokenAddress =
        '0x${(mock.id * 2 + 2).toRadixString(16).padLeft(40, '0').toUpperCase()}';

    return PredictionModel(
      id: mock.id,
      prompt: mock.prompt,
      details: mock.details,
      marketAddress: marketAddress,
      yesTokenAddress: yesTokenAddress,
      noTokenAddress: noTokenAddress,
      yesName: 'YES',
      noName: 'NO',
      tradingVolume: tradingVolume,
      time: mock.endDate,
      longTokenPrice: yesPrice,
      shortTokenPrice: noPrice,
      longTokenPercentage: yesPrice * 100,
      shortTokenPercentage: noPrice * 100,
      longTokenPriceUsd: yesPrice,
      shortTokenPriceUsd: noPrice,
      supportedPredictionMarkets: mock.category,
    );
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

  /// This function returns the current market price
  // ignore: unused_element
  PredictionMarketModel _getMarketModel(
    String strTokenAddr, {
    required Token axt,
  }) {
    final strAXTAddr = axt.address;
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

    var marketPrice = 0.0;
    if (index0 >= 0) {
      marketPrice = double.parse(allPairs[index0].reserve1) /
          double.parse(allPairs[index0].reserve0);
    } else if (index1 >= 0) {
      marketPrice = double.parse(allPairs[index1].reserve0) /
          double.parse(allPairs[index1].reserve1);
    }

    var recentPrice = marketPrice;
    if (index0 >= 0 && allPairs[index0].pairHourData!.isNotEmpty) {
      recentPrice = double.parse(allPairs[index0].pairHourData![0].reserve1) /
          double.parse(allPairs[index0].pairHourData![0].reserve0);
    } else if (index1 >= 0 && allPairs[index1].pairHourData!.isNotEmpty) {
      recentPrice = double.parse(allPairs[index1].pairHourData![0].reserve0) /
          double.parse(allPairs[index1].pairHourData![0].reserve1);
    }

    return PredictionMarketModel(
      marketPrice: marketPrice,
      recentPrice: recentPrice,
    );
  }

  Future<List<TokenPair>> fetchSpecificPairs(
    Token token,
    String startDate, {
    bool isLimited = true,
  }) async {
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

  List<PriceRecord> _generateMockSeries(
    Random random,
    DateTime start,
    double startPrice, {
    bool invert = false,
    int days = 30,
  }) {
    final series = <PriceRecord>[];
    var price = startPrice;

    for (var i = 0; i < days; i++) {
      final drift = (random.nextDouble() - 0.5) * 0.08;
      price = (price + drift).clamp(0.05, 0.95);
      final adjustedPrice = invert ? 1 - price : price;
      series.add(
        PriceRecord(
          price: double.parse(adjustedPrice.toStringAsFixed(4)),
          timestamp: start.add(Duration(days: i)).toIso8601String(),
        ),
      );
    }

    return series;
  }
}

class _MockPredictionMarket {
  const _MockPredictionMarket({
    required this.id,
    required this.prompt,
    required this.details,
    required this.category,
    required this.endDate,
  });

  final int id;
  final String prompt;
  final String details;
  final SupportedPredictionMarkets category;
  final String endDate;
}
