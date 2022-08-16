// ignore_for_file: avoid_dynamic_calls

import 'package:ax_dapp/pages/scout/models/athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/models/book_price_model.dart';
import 'package:ax_dapp/pages/scout/models/market_model.dart';
import 'package:ax_dapp/pages/scout/models/sports_model/mlb_athlete_scout_model.dart';
import 'package:ax_dapp/pages/scout/models/sports_model/nfl_athlete_scout_model.dart';
import 'package:ax_dapp/repositories/coin_gecko_repo.dart';
import 'package:ax_dapp/repositories/sports_repo.dart';
import 'package:ax_dapp/repositories/subgraph/sub_graph_repo.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_athlete_stats.dart';
import 'package:ax_dapp/service/athlete_models/mlb/mlb_stats.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_athlete_stats.dart';
import 'package:ax_dapp/service/athlete_models/nfl/nfl_stats.dart';
import 'package:ax_dapp/service/athlete_models/sport_athlete.dart';
import 'package:ax_dapp/service/blockchain_models/token_pair.dart';
import 'package:ax_dapp/service/controller/swap/axt.dart';
import 'package:ax_dapp/service/token_list.dart';
import 'package:ax_dapp/util/supported_sports.dart';
import 'package:intl/intl.dart';

class GetScoutAthletesDataUseCase {
  GetScoutAthletesDataUseCase({
    required this.graphRepo,
    required this.coinGeckoRepo,
    required List<SportsRepo<SportAthlete>> sportsRepos,
  }) {
    for (final repo in sportsRepos) {
      _repos[repo.sport] = repo;
    }
  }
  static const collateralizationMultiplier = 1000;
  static const collateralizationPerPair = 15;
  final SubGraphRepo graphRepo;
  final CoinGeckoRepo coinGeckoRepo;
  final Map<SupportedSport, SportsRepo<SportAthlete>> _repos = {};
  List<TokenPair> allPairs = [];

  Future<double> fetchAxPrice() async {
    final axMarketData = await coinGeckoRepo.getAxPrice();
    final axDataByCurrency = axMarketData.data?.marketData?.dataByCurrency;
    final axPrice =
        axDataByCurrency?.firstWhere((axPrice) => axPrice.coinId == 'usd');
    return axPrice?.currentPrice ?? 0.0;
  }

  Future<List<dynamic>> getStatsHistory(
    SportsRepo<SportAthlete> repo,
    List<SportAthlete> players,
  ) async {
    final ids = players.map((player) => player.id).toList();
    // currently the api is not working with current date
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day - 1);

    // this code is used to test the api, because api is not working correctly
    // final now = DateTime(2022, 8, 2);
    // final startDate = DateTime(2022, 8, 1);
    final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedEndDate = DateFormat('yyyy-MM-dd').format(now);
    try {
      final histories = await repo.getPlayersStatsHistory(
        ids,
        formattedStartDate,
        formattedEndDate,
      );
      return histories;
    } catch (e) {
      final histories = players
          .asMap()
          .map((key, player) {
            dynamic history;
            if (repo.sport == SupportedSport.MLB) {
              history = MLBAthleteStats(
                id: player.id,
                name: player.name,
                team: player.team,
                position: player.position,
                statHistory: [
                  const MLBStats(
                    started: 0,
                    games: 0,
                    atBats: 0,
                    runs: 0,
                    singles: 0,
                    triples: 0,
                    homeRuns: 0,
                    inningsPlayed: 0,
                    battingAverage: 0,
                    outs: 0,
                    walks: 0,
                    errors: 0,
                    saves: 0,
                    strikeOuts: 0,
                    stolenBases: 0,
                    plateAppearances: 0,
                    weightedOnBasePercentage: 0,
                    price: 0,
                    timeStamp: '2022',
                  ),
                ].toList(),
              );
            } else if (repo.sport == SupportedSport.NFL) {
              history = NFLAthleteStats(
                id: player.id,
                name: player.name,
                team: player.team,
                position: player.position,
                statHistory: [
                  const NFLStats(
                    passingYards: 0,
                    passingTouchDowns: 0,
                    reception: 0,
                    receiveYards: 0,
                    receiveTouch: 0,
                    rushingYards: 0,
                    offensiveSnapsPlayed: 0,
                    defensiveSnapsPlayed: 0,
                    price: 0,
                    timeStamp: '2022',
                  ),
                ].toList(),
              );
            }
            return MapEntry(key, history);
          })
          .values
          .toList();
      return histories;
    }
  }

  Future<List<AthleteScoutModel>> fetchSupportedAthletes(
    SupportedSport sportSelection,
  ) async {
    allPairs = await fetchSpecificPairs('AX');
    //fetching AX Price
    final axPrice = await fetchAxPrice();

    /// If specific sport is selected return athletes from that specific repo
    if (sportSelection != SupportedSport.all) {
      final repo = _repos[sportSelection]!;
      // fetch supported players list
      final players = await repo.getSupportedPlayers();
      final history = await getStatsHistory(repo, players);
      return _mapAthleteToScoutModel(players, history, repo, axPrice);
    } else {
      /// if ALL sports is selected fetch for each sport and add athletes to a
      /// combined list
      final athletes = <AthleteScoutModel>[];
      final response = await Future.wait(
        _repos
            .map((key, repo) => MapEntry(key, repo.getSupportedPlayers()))
            .values,
      );

      final histories = await Future.wait(
        response.asMap().map((key, response) {
          final repo = _repos.values.elementAt(key);
          return MapEntry(key, getStatsHistory(repo, response));
        }).values,
      );

      response.asMap().forEach((key, response) {
        final repo = _repos.values.elementAt(key);
        final history = histories.elementAt(key);
        athletes.addAll(
          _mapAthleteToScoutModel(
            response,
            history,
            repo,
            axPrice,
          ),
        );
      });
      return athletes;
    }
  }

  Future<List<TokenPair>> fetchSpecificPairs(String token) async {
    final response = await graphRepo.querySpecificPairs(token);
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
  }

  MarketModel getMarketModel(String strTokenAddr, double bookPrice) {
    final strAXTAddr = AXT.polygonAddress.toUpperCase();
    // Looking for a pair which has the same token name as strTokenAddr
    // (token address as uppercase)
    final index0 = allPairs.indexWhere(
      (pair) =>
          pair.token0.id.toUpperCase() == strTokenAddr &&
          pair.token1.id.toUpperCase() == strAXTAddr,
    );
    final index1 = allPairs.indexWhere(
      (pair) =>
          pair.token0.id.toUpperCase() == strAXTAddr &&
          pair.token1.id.toUpperCase() == strTokenAddr,
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
    return MarketModel(
      marketPrice: marketPrice,
      recentPrice: recentPrice,
      bookPrice: bookPrice * collateralizationMultiplier,
    );
  }

  BookPriceModel getBookPricePercentage(
    double startPrice,
    double endPrice,
  ) {
    return BookPriceModel(startPrice: startPrice, endPrice: endPrice);
  }

  List<AthleteScoutModel> _mapAthleteToScoutModel(
    List<SportAthlete> athletes,
    List<dynamic> histories,
    SportsRepo<SportAthlete> repo,
    double axPrice,
  ) {
    // final mappedAthletes = <AthleteScoutModel>[];
    // for (final athlete in athletes) {
    final mappedAthletes = athletes.asMap().map((key, athlete) {
      final isIdFound = TokenList.idToAddress.containsKey(athlete.id);
      final strLongTokenAddr =
          isIdFound ? TokenList.idToAddress[athlete.id]![1].toUpperCase() : '';
      final strShortTokenAddr =
          isIdFound ? TokenList.idToAddress[athlete.id]![2].toUpperCase() : '';

      final history = histories.elementAt(key);

      final longToken = getMarketModel(strLongTokenAddr, athlete.price);
      final shortToken = getMarketModel(
        strShortTokenAddr,
        collateralizationPerPair - athlete.price,
      );

      final length = history.statHistory.length;
      final startPrice = history.statHistory[0].price as double;
      final endPrice = history.statHistory[length - 1].price as double;
      final longBookModel = getBookPricePercentage(
        startPrice,
        endPrice,
      );
      final shortBookModel = getBookPricePercentage(
        collateralizationPerPair - startPrice,
        collateralizationPerPair - endPrice,
      );

      AthleteScoutModel athleteScoutModel;
      switch (repo.sport) {
        case SupportedSport.MLB:
          {
            final mlbAthlete = athlete as MLBAthlete;
            athleteScoutModel = MLBAthleteScoutModel(
              id: mlbAthlete.id,
              name: mlbAthlete.name,
              position: mlbAthlete.position,
              team: mlbAthlete.team,
              longTokenBookPrice: longToken.bookPrice,
              longTokenBookPriceUsd: longToken.bookPrice * axPrice,
              longTokenBookPricePercent: longBookModel.percentage,
              shortTokenBookPrice: shortToken.bookPrice,
              shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
              shortTokenBookPricePercent: shortBookModel.percentage,
              sport: repo.sport,
              time: mlbAthlete.timeStamp,
              longTokenPrice: longToken.marketPrice,
              shortTokenPrice: shortToken.marketPrice,
              longTokenPriceUsd: longToken.marketPrice * axPrice,
              shortTokenPriceUsd: shortToken.marketPrice * axPrice,
              longTokenPercentage: longToken.percentage,
              shortTokenPercentage: shortToken.percentage,
              homeRuns: mlbAthlete.homeRuns,
              strikeOuts: mlbAthlete.strikeOuts,
              saves: mlbAthlete.saves,
              stolenBases: mlbAthlete.stolenBases,
              atBats: mlbAthlete.atBats,
              weightedOnBasePercentage: mlbAthlete.weightedOnBasePercentage,
              errors: mlbAthlete.errors,
              inningsPlayed: mlbAthlete.inningsPlayed,
            );
          }
          break;
        case SupportedSport.NFL:
          {
            final nflAthlete = athlete as NFLAthlete;
            athleteScoutModel = NFLAthleteScoutModel(
              id: nflAthlete.id,
              name: nflAthlete.name,
              position: nflAthlete.position,
              team: nflAthlete.team,
              longTokenBookPrice: longToken.bookPrice,
              longTokenBookPriceUsd: longToken.bookPrice * axPrice,
              longTokenBookPricePercent: longBookModel.percentage,
              shortTokenBookPrice: shortToken.bookPrice,
              shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
              shortTokenBookPricePercent: shortBookModel.percentage,
              sport: repo.sport,
              time: nflAthlete.timeStamp,
              longTokenPrice: longToken.marketPrice,
              shortTokenPrice: shortToken.marketPrice,
              longTokenPercentage: longToken.percentage,
              shortTokenPercentage: shortToken.percentage,
              longTokenPriceUsd: longToken.marketPrice * axPrice,
              shortTokenPriceUsd: shortToken.marketPrice * axPrice,
              passingYards: nflAthlete.passingYards,
              passingTouchDowns: nflAthlete.passingTouchDowns,
              reception: nflAthlete.reception,
              receiveYards: nflAthlete.receiveYards,
              receiveTouch: nflAthlete.receiveTouch,
              rushingYards: nflAthlete.rushingYards,
              offensiveSnapsPlayed: nflAthlete.offensiveSnapsPlayed,
              defensiveSnapsPlayed: nflAthlete.defensiveSnapsPlayed,
            );
          }
          break;
        // ignore: no_default_cases
        default:
          {
            athleteScoutModel = AthleteScoutModel(
              id: athlete.id,
              name: athlete.name,
              position: athlete.position,
              team: athlete.team,
              longTokenBookPrice: longToken.bookPrice,
              longTokenBookPriceUsd: longToken.bookPrice * axPrice,
              longTokenBookPricePercent: longBookModel.percentage,
              shortTokenBookPrice: shortToken.bookPrice,
              shortTokenBookPriceUsd: shortToken.bookPrice * axPrice,
              shortTokenBookPricePercent: shortBookModel.percentage,
              // TODO(anyone): check for sport
              sport: repo.sport,
              time: athlete.timeStamp,
              longTokenPrice: longToken.marketPrice,
              shortTokenPrice: shortToken.marketPrice,
              longTokenPercentage: longToken.percentage,
              shortTokenPercentage: shortToken.percentage,
              longTokenPriceUsd: longToken.marketPrice * axPrice,
              shortTokenPriceUsd: shortToken.marketPrice * axPrice,
            );
          }
      }
      return MapEntry(key, athleteScoutModel);
    });
    return mappedAthletes.values.toList();
  }
}
